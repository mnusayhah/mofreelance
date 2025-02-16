module Freelancer
  class SharedProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_freelancer!


    # GET freelancer/shared_projects
    def index
        # Get only shared projects where the current user is the freelancer
      @shared_projects = SharedProject.includes(:project).where(freelancer_id: current_user.id, status: :accepted)

    end

    # GET /freelancer/shared_projects/:id
    def show
      @shared_project = SharedProject.find_by(id: params[:id], freelancer_id: current_user.id, status: :accepted)

      if @shared_project.nil?
        redirect_to freelancer_shared_projects_path, alert: "Project not found or not accepted."
      end
    end

    def accept
      @shared_project = SharedProject.find_by(id: params[:id], freelancer_id: current_user.id)

      if @shared_project&.pending?
        @shared_project.update(status: :accepted)
        redirect_to freelancer_shared_projects_path, notice: "Project accepted successfully."
      else
        redirect_to freelancer_shared_projects_path, alert: "Project cannot be accepted."
      end
    end

    def decline
      @shared_project = SharedProject.find_by(id: params[:id], freelancer_id: current_user.id)

      if @shared_project&.pending?
        @shared_project.update(status: :declined)
        redirect_to freelancer_shared_projects_path, notice: "Project declined successfully."
      else
        redirect_to freelancer_shared_projects_path, alert: "Project cannot be declined."
      end
    end


    private
    def ensure_freelancer!
      unless current_user.role == "freelancer"
        redirect_to root_path, alert: "Access denied! You must be a freelancer."
      end
    end

    # Strong params for shared projects
    def shared_project_params
      params.require(:shared_project).permit(:name, :description, :project_id, :freelancer_id)
    end

    # Authorization check for enterprise users if we need to include create, edit and update methods
    def authorize_enterprise!
      unless current_user.role == 'enterprise'
        redirect_to root_path, alert: 'Access denied. Only Enterprise users can perform this action.'
      end
    end

    def set_shared_project
      @shared_project = SharedProject.find_by(id: params[:id]) # Use find_by to avoid exceptions if not found
      if @shared_project.nil?
        redirect_to shared_projects_path, alert: "No project found."
      end
    end
  end
end
