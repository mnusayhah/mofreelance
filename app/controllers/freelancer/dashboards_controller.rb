module Freelancer
  class DashboardsController < ApplicationController
    before_action :authenticate_user!

    def show
      @freelancer = current_user
      @projects = @freelancer.projects.joins(:shared_projects).where(shared_projects: { status: ['pending', 'accepted'] })
      # @projects = @freelancer.projects.where(freelancer_projects: { status: 'pending' })
      # @pending_projects = current_user.projects.where(status: 0)
    end

    def freelancer
      @ongoing_projects = current_user.shared_projects.where(status: 1)
      @pending_projects = current_user.shared_projects.where(status: 0)
      @completed_projects = current_user.shared_projects.where(status: 4)

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

  end
end
