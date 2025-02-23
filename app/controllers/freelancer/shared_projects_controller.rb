module Freelancer
  class SharedProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_freelancer!
    before_action :set_shared_project, only: [:update]

    def index
      @shared_projects = SharedProject.all
      # where(status: params[:status]) # Fetch projects dynamically

      # respond_to do |format|
      #   format.html # Normal request (for full page loads)
      #   format.turbo_stream do
      #     render turbo_stream: turbo_stream.update("projects_frame",
      #       partial: "projects_list", locals: { projects: @projects }
      #     )
      #   end
      # end
    end


    def share_project
      @project = Project.find(params[:id])
      @freelancer = User.find(params[:freelancer_id])

      @shared_project = SharedProject.create(
        project: @project,
        freelancer: @freelancer,
        status: :pending
      )

      # Update the project status to pending
      @project.update(status: :pending)

      # Additional logic if needed (redirect, success message, etc.)
    end

    def update
      if @shared_project.update(shared_project_params)
        if @shared_project.accepted? && @shared_project.project.status != 'ongoing'
          @shared_project.project.update(status: :ongoing)
        end
        respond_to do |format|
          format.html { redirect_to @shared_project, notice: "Project status updated successfully." }
          format.js   # This will handle remote updates (AJAX)
        end
      else
        render :show
      end
    end

    # GET freelancer/shared_projects
    # def index
    #     # Get only shared projects where the current user is the freelancer
    #   @shared_projects = SharedProject.includes(:project).where(freelancer_id: current_user.id, status: :accepted)

    # end

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
