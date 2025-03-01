class Profile < ApplicationRecord
  include PgSearch::Model
  belongs_to :user
  has_many :educations, inverse_of: :profile
  has_many :skills, inverse_of: :profile

  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true
  
  has_many :received_reviews, class_name: "Review", foreign_key: "rated_user_id"
  has_one_attached :photo

  validates :tech_skills, presence: false

# Recherche via pg_search
pg_search_scope :search_by_freelancer_data,
against: [:title, :bio, :address, :language, :tech_skills],
associated_against: {
  skills: [:job_title, :description, :company]
},
using: {
  tsearch: { prefix: true }
}

end
