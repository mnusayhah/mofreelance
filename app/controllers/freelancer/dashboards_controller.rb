module Freelancer
  class DashboardsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_freelancer!


    def show
      @pending_projects = current_user.projects.where(status: 0)
      @shared_projects = SharedProject.where(freelancer_id: current_user.id)

    end

    def freelancer
      @ongoing_projects = current_user.shared_projects.where(status: 'accepted')
      @pending_projects = current_user.shared_projects.where(status: 'pending')
      @completed_projects = current_user.shared_projects.where(status: 'completed')

      # respond_to do |format|
      #   format.html  # Full page load
      #   format.turbo_stream do
      #     render turbo_stream: turbo_stream.replace(params[:turbo_frame], partial: "projects_list", locals: { projects: instance_variable_get("@#{params[:turbo_frame]}") })
      #   end
      # end
    end

    def profile
    end

    def projects
      # @projects = current_user.shared_projects.where(status: params[:status])
      # respond_to do |format|
      #   format.turbo_stream
      #   format.html { render partial: "projects_list", locals: { projects: @projects } }
      # end
    end

    private

    def ensure_freelancer!
      unless current_user.role == "freelancer"
        redirect_to root_path, alert: "Access denied! You must be a freelancer."
      end
    end

  end
end
