class Profile < ApplicationRecord
  belongs_to :user
  has_many :educations, dependent: :destroy
  has_many :skills, dependent: :destroy
  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true
  has_many :received_reviews, class_name: "Review", foreign_key: "rated_user_id"
  has_one_attached :avatar

  validates :tech_skills, presence: false
end
