class SharedProject < ApplicationRecord
  belongs_to :project
  belongs_to :freelancer, class_name: 'User'

  enum status: {pending: 0, accepted: 1, declined: 2, paid: 3, completed: 4}

  after_update :create_discussion_after_acceptance
  after_update :update_project_status_on_acceptance

  private

  def create_discussion_after_acceptance
    # if saved_change_to_status? && accepted? && project.discussion.nil?
    #   Discussion.create(project: project)
    # end
  end

  def update_project_status_on_acceptance
    # If freelancer accepts the project, set project to ongoing
    if accepted? && project.status != 'ongoing'
      project.update(status: :ongoing)
    end
  end

  def update_project_status_on_decline
    # If freelancer accepts the project, set project to ongoing
    if declined? && project.status != 'open'
      project.update(status: :open)
    end
  end

  # def update_project_status_on_payment_received
  #   # If freelancer accepts the project, set project to ongoing
  #   if paid? && project.status != 'completed'
  #     project.update(status: :completed)
  #   end
  # end
end
