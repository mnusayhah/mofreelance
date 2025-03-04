class Skill < ApplicationRecord
  validates :job_title, :company, :start_date, :end_date, presence: true
  belongs_to :profile
end
