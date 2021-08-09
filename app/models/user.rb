class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one :profile
  has_many :posts
  has_many :comments
  has_many :likes
  
  has_many :notifications, foreign_key: "receiver_id"
  has_many :friend_requests, foreign_key: "receiver_id"
  has_many :sent_friend_requests, class_name: "FriendRequest", foreign_key: "sender_id"
  scope :sent_request_to, ->(user) { joins("INNER JOIN friend_requests ON users.id = friend_requests.sender_id").where(friend_requests: {receiver_id: user.id})}
  scope :received_request_from, ->(user) { joins("INNER JOIN friend_requests ON users.id = friend_requests.receiver_id").where(friend_requests: {sender_id: user.id})}
  scope :not_pending_with, ->(user) { where.not(id: sent_request_to(user).ids.concat(received_request_from(user).ids))}

  has_many :friendships
  has_many :friends, through: :friendships
  scope :not_friends_with, ->(user) { where.not(id: joins(:friendships).select(:friend_id).where(id: user.id)).where.not(id: user.id)}
end
