class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { freelancer: 0, enterprise: 1}

  validates :first_name, :last_name, presence: true
  validates :company, presence: true, if: :enterprise?

  has_one :profile, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :shared_projects_as_freelancer, through: :shared_projects, source: :project
  has_many :reviews_given, class_name: 'Review', foreign_key: :user_id, dependent: :destroy
  has_many :reviews_received, class_name: 'Review', foreign_key: :rated_user_id, dependent: :destroy
  has_many :discussions_as_freelancer, class_name: 'Discussion', foreign_key: :freelancer_id, dependent: :destroy
  has_many :discussions_as_enterprise, class_name: 'Discussion', foreign_key: :enterprise_id, dependent: :destroy
  has_many :messages_sent, class_name: 'Message', foreign_key: :sender_id, dependent: :destroy
  has_many :messages_received, class_name: 'Message', foreign_key: :receiver_id, dependent: :destroy
end
