class FriendRequest < ApplicationRecord

    after_create do
        self.create_friend_request_notification(receiver_id: self.receiver_id,
                                                status: "Unread")
    end

    has_one :friend_request_notification, as: :notifiable
    belongs_to :sender, class_name: "User"
    belongs_to :receiver, class_name: "User"
    validate :no_self_friendship, on: :create
    
    valid_statuses = ["Accepted", "Declined", "Unanswered"]
    validates :status, inclusion: { in: valid_statuses }
    
    scope :pending, -> { where(status: "Unanswered")}
    
    def self.exists_between?(user_one, user_two)
        self.find_by(sender_id: user_one.id, receiver_id: user_two.id) ||
        self.find_by(sender_id: user_two.id, receiver_id: user_one.id)
    end

    def pending?
        self.status == "Unanswered"
    end

    private
    def no_self_friendship
        errors.add(:receiver_id, "can't be yourself") unless sender != receiver
    end

end
