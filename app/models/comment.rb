class Comment < ApplicationRecord
    has_one :comment_notification, as: :notifiable
    belongs_to :user
    belongs_to :post

    validates :body, presence: true

    after_create do
        unless self.user == self.post.user
            self.create_comment_notification(receiver_id: self.post.user.id,
                                             status: "Unread")
        end
    end
end
