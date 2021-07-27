class Friendship < ApplicationRecord
    #Create an additional, opposing record
    after_create do |friendship|
        Friendship.find_or_create_by(user_id: friendship.friend_id, friend_id: friendship.user_id)
    end
    #Destroy the opposing record
    after_destroy do 
        Friendship.find_by(user_id: self.friend_id, friend_id: self.user_id)&.delete
    end

    belongs_to :user
    belongs_to :friend, class_name: "User"

    validate :no_self_friendship

    def no_self_friendship
        errors.add(:friend, "can't be yourself") unless user != friend 
    end
end
