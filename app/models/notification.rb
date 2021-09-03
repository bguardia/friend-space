class Notification < ApplicationRecord
    belongs_to :receiver, class_name: "User"
    belongs_to :notifiable, polymorphic: true

    @@valid_statuses = ["Unread", "Read", "Archived"]
    before_validation :set_default_status
    validates :status, inclusion: { in: @@valid_statuses }

    default_scope { order(created_at: :desc) }
    scope :unarchived, -> { where.not(status: "Archived") }
    
    

    def set_default_status
        self.status = @@valid_statuses.first if self.status.nil?
    end

    def partial
        #Return a string with the name of the notification's partial to render
        'notifications/general_notification'
    end
end
