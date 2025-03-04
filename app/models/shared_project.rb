class SharedProject < ApplicationRecord
  belongs_to :project
  belongs_to :freelancer, class_name: 'User'

  enum status: {pending: 0, accepted: 1, declined: 2, paid: 3, completed: 4}

  after_update :create_discussion_after_acceptance
  after_update :update_project_status_on_acceptance
  after_update :update_project_status_on_decline
  after_update :update_project_and_shared_project_status_on_paid

  def update_project_and_shared_project_status_on_paid
    # If freelancer accepts the project, set project to ongoing
    if paid? && project.status != 'completed'
      project.update(status: :completed)
    end
  end

  def mark_payment_received
    if status == 'paid'
      update(status: :completed)
      project.update(status: :completed)
    end
  end

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
    # If freelancer declines the project, set project to open
    if declined? && project.status != 'open'
      project.update(status: :open)
    end
  end
end
