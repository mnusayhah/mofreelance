class SharedProject < ApplicationRecord
  belongs_to :project
  belongs_to :freelancer, class_name: 'User'

  enum status: {pending: 0, accepted: 1, declined: 2, paid: 3, completed: 4}
  
  after_update :create_discussion_after_acceptance

  private

  def create_discussion_after_acceptance
    if saved_change_to_status? && accepted? && project.discussion.nil?
      Discussion.create(project: project)
    end
  end
end
