class Review < ApplicationRecord
  belongs_to :user
  belongs_to :rated_user, class_name: 'User'
  belongs_to :project

  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
end

