class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[facebook]
  
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  has_many :notifications, foreign_key: "receiver_id", dependent: :destroy
  has_many :friend_requests, foreign_key: "receiver_id", dependent: :destroy
  has_many :sent_friend_requests, class_name: "FriendRequest", foreign_key: "sender_id", dependent: :destroy
  scope :sent_request_to, ->(user) { joins("INNER JOIN friend_requests ON users.id = friend_requests.sender_id").where(friend_requests: {receiver_id: user.id})}
  scope :received_request_from, ->(user) { joins("INNER JOIN friend_requests ON users.id = friend_requests.receiver_id").where(friend_requests: {sender_id: user.id})}
  scope :not_pending_with, ->(user) { where.not(id: sent_request_to(user).ids.concat(received_request_from(user).ids))}

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  scope :not_friends_with, ->(user) { where.not(id: joins(:friendships).select(:friend_id).where(id: user.id)).where.not(id: user.id)}

  after_create do
    self.create_profile unless self.profile
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.build_profile(firstname: auth.info.first_name,
                         lastname: auth.info.last_name)
      if auth.info.image
        begin
        tempfile = Down.download(auth.info.image, max_size: 5 * 1024 * 1024) #5MB
        user.profile.avatar.attach(io: tempfile,
                                   filename: tempfile.original_filename, 
                                   content_type: tempfile.content_type)
        File.delete(tempfile)
        rescue Down::NotFound
          logger.info "Could not download user profile photo"
        end
      end
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
end
