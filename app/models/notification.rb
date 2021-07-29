class Notification < ApplicationRecord
    belongs_to :receiver, class_name: "User"
    belongs_to :notifiable, polymorphic: true

    valid_statuses = ["Unread", "Read", "Archived"]
    validates :status, inclusion: { in: valid_statuses }

    scope :unarchived, -> { where.not(status: "Archived") }
    
    def partial
        #Return a string with the name of the notification's partial to render
        'notifications/general_notification'
    end
end
