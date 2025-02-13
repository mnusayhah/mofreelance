class Profile < ApplicationRecord
  belongs_to :user
  has_many :educations
  has_many :skills
end
