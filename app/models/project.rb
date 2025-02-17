class Project < ApplicationRecord
  belongs_to :user

  has_many :discussions, dependent: :destroy
  has_many :shared_projects, dependent: :destroy
  has_many :reviews, dependent: :destroy

  after_update :create_discussion_if_accepted

  private

  def create_discussion_if_accepted
    if self.saved_change_to_status? && self.status == "accepted"
      Discussion.find_or_create_by(project: self)
    end
  end
end
