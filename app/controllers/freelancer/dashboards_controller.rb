module Freelancer
  class DashboardsController < ApplicationController
    before_action :authenticate_user!


    def show
      @pending_projects = current_user.projects.where(status: 0)
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

  end
end
