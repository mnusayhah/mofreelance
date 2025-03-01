class Project < ApplicationRecord
  belongs_to :user

  has_many :discussions, dependent: :destroy
  has_many :shared_projects, dependent: :destroy
  has_many :reviews, dependent: :destroy

  enum status: { open: 0, pending: 1, ongoing: 2, paid: 3, completed: 4, archived: 5 }

  validates :status, presence: true

  after_initialize :set_default_status, if: :new_record?
  after_update :create_discussion_if_accepted
  # after_update :archive_project_if_completed_for_30_days

  private

  def set_default_status
    self.status ||= :open # This will default to :open if no status is set
  end

  def create_discussion_if_accepted
    if self.saved_change_to_status? && self.status == "accepted"
      Discussion.find_or_create_by(project: self)
    end
  end

  # def archive_project_if_completed_for_30_days
  #   if completed? && completed_at && completed_at < 30.days.ago
  #     self.update(status: :archived)
  #   end
  # end

  has_many :freelancers, through: :shared_projects, source: :user
end
