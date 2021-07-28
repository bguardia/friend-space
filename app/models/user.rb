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

  has_many :friendships
  has_many :friends, through: :friendships
end
