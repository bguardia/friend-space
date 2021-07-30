class Profile < ApplicationRecord
    belongs_to :user
    has_one_attached :avatar
    
    validates :firstname, presence: true
    validates :lastname, presence: true
end
