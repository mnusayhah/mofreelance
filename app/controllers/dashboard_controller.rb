class DashboardController < ApplicationController
  #before_action :authenticate_user!

  def company
    @user = current_user
    # Fetch the company (current_user) projects
    @ongoing_projects = @user.projects.where(status: 'ongoing')
    @archived_projects = @user.projects.where(status: 'archived')
  end
end
