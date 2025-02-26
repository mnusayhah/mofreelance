module Enterprise
  class DashboardsController < ApplicationController
    before_action :authenticate_user!

    def enterprise
      @user = current_user
      @projects = current_user.projects

    end

    def dashboard
      @ongoing_projects = current_user.projects.where(status: 2)
      @archived_projects = current_user.projects.where(status: 5)
      # @projects = current_user.projects.ongoing
      render partial: "projects_table", locals: { projects: @projects }
    end

    def change_content
      case params[:status]
      when '2'
        @projects = Project.ongoing
      when '5'
        @projects = Project.archived
      else
        @projects = Project.my_projects(current_user)
      end

      render partial: 'projects_table', locals: { projects: @projects }
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

      @profiles = User.where(role: 'freelancer')
    end
  end
end
