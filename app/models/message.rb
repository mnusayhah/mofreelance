class Message < ApplicationRecord
  belongs_to :discussion
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

end
