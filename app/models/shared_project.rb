class SharedProject < ApplicationRecord
  belongs_to :project
  belongs_to :freelancer, class_name: 'User'

  enum status: {pending: 0, accepted: 1, declined: 2, paid: 3, completed: 4}

end
