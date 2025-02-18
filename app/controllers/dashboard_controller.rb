class DashboardController < ApplicationController
  before_action :authenticate_user!

  def company
    @user = current_user
    @projects = current_user.projects
    @ongoing_projects = @user.projects.where(status: 'ongoing')
    @archived_projects = @user.projects.where(status: 'archived')
  end

  def dashboard
    @projects = current_user.projects.ongoing
    render partial: "projects_table", locals: { projects: @projects }
  end

  def update_content
    render partial: 'new_content'
  end

  def index
    @projects = current_user.projects

    if request.xhr?
      render partial: "projects_table", locals: { projects: @projects }
    else
      render 'company'
    end
  end
end
