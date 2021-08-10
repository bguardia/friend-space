class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, as: :likeable, dependent: :destroy
    has_one_attached :image

    validates :body, presence: true, unless: Proc.new { |p| p.image.attached? }
end
