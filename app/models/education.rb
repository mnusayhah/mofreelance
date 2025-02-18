class Education < ApplicationRecord
  validates :school, :diploma, :start_date, :end_date, presence: true
  belongs_to :profile
end
