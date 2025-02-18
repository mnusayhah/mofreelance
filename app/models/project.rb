class Project < ApplicationRecord
  belongs_to :user

  has_many :discussions, dependent: :destroy
  has_many :shared_projects, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :freelancers, through: :shared_projects, source: :user
end
