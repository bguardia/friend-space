class Poke < ApplicationRecord
  has_one :poke_notification, as: :notifiable
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  after_create do 
    self.create_poke_notification(receiver_id: receiver.id,
                                  status: "Unread")
  end
  
  validate :between_friends

  def between_friends
    errors.add(:receiver, "can't poke non-friends") unless sender.friends.exists?(receiver.id)
  end
end
