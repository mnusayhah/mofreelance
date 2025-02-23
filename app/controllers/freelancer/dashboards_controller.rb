module Freelancer
  class DashboardsController < ApplicationController
    before_action :authenticate_user!

    def freelancer
        @shared_projects = current_user.shared_projects.includes(:project)

        respond_to do |format|
          format.html # Normal request (for full page loads)
          format.turbo_stream do
            render turbo_stream: turbo_stream.update("projects_frame",
            partial: "projects_list", locals: { projects: @projects }
          )
          end
        end
    end

    def dashboard
      @ongoing_projects = current_user.shared_projects.where(status: 1)
      @pending_projects = current_user.shared_projects.where(status: 0)
      @completed_projects = current_user.shared_projects.where(status: 4)
    end

      # def show
      #     @projects = freelancer.projects
      #
      # end

    def profile
    end

    def projects
      @projects = current_user.shared_projects.where(status: params[:status])
      respond_to do |format|
        format.turbo_stream
        format.html { render partial: "projects_list", locals: { projects: @projects } }
      end
    end

  end
end
