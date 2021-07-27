class FriendRequest < ApplicationRecord
    has_one :friend_request_notification, as: :notifiable
    belongs_to :sender, class_name: "User"
    belongs_to :receiver, class_name: "User"
    validate :no_self_friendship, on: :create
    
    valid_statuses = ["Accepted", "Declined", "Unanswered"]
    validates :status, inclusion: { in: valid_statuses }
    
    
    def no_self_friendship
        errors.add(:receiver_id, "can't be yourself") unless sender != receiver
    end
end
