class Profile < ApplicationRecord
    belongs_to :user
    has_one_attached :avatar
    
    before_validation :set_default_values
    validates :firstname, presence: true
    validates :lastname, presence: true

    def set_default_values
        self.firstname ||= "User"
        self.lastname ||= self.user_id.to_s
    end
end
