class Discussion < ApplicationRecord
  belongs_to :project
  belongs_to :freelancer, class_name: 'User'
  belongs_to :enterprise, class_name: 'User'

  has_many :messages, dependent: :destroy
end
