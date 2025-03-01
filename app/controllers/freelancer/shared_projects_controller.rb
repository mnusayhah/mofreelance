module Freelancer
  class SharedProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_freelancer!
    before_action :set_shared_project, only: [:update]

    def index
      @shared_projects = SharedProject.where(freelancer_id: current_user.id)
      @pending_projects = SharedProject.where(status: 0)
      @accepted_projects = SharedProject.where(status: 1)
      @completed_projects = SharedProject.where(status: 4)


      # respond_to do |format|
      #   format.turbo_stream { render partial: "projects_list", locals: { shared_projects: @shared_projects } }
      #   format.html # This handles full-page loads (fallback)
      # end

    end

    def ongoing_projects
      @shared_projects = SharedProject.where(freelancer_id: current_user.id).where(status: 1)
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
      @shared_project = SharedProject.find(params[:id])

      if @shared_project.update(shared_project_params)
        respond_to do |format|
          format.html { redirect_to freelancer_shared_projects_path, notice: "Project status updated." }
          format.turbo_stream
        end
      else
        render :edit
      end
    end

# GET /freelancer/shared_projects/:id
    def show
      @shared_project = SharedProject.find_by(id: params[:id], freelancer_id: current_user.id)
      respond_to do |format|
        format.html # Normal full-page load
        format.turbo_stream { render partial: "shared_projects/show", locals: { shared_project: @shared_project } }
      end
      if @shared_project.nil?
        redirect_to freelancer_shared_projects_path, alert: "Project not found."
      end
    end


    def accept
      @project = Project.find(params[:id])  # Find the project the freelancer wants to accept
      @freelancer = current_freelancer       # Get the currently logged-in freelancer

      # Check if the freelancer has already accepted the project
      if @project.freelancers.include?(@freelancer)
        redirect_to freelancer_dashboard_path, notice: 'You have already accepted this project.'
        return
      end

      # Create the FreelancerProject join record with status 'pending'
      @freelancer_project = @project.freelancer_projects.create(freelancer: @freelancer, status: :pending)

      # Optionally, update the project status to 'pending' if the first freelancer accepts it
      @project.update(status: :pending)

      redirect_to freelancer_dashboard_path, notice: 'You have successfully accepted the project.'
    end


    # def accept
    #   @shared_project = SharedProject.find(params[:id])
    #   if @shared_project.update(status: 'accepted')
    #     # You can add Turbo Streams to update the status in the view without refreshing the page.
    #     respond_to do |format|
    #       format.html { redirect_to freelancer_shared_projects_path, notice: 'Project accepted.' }
    #       format.turbo_stream { render turbo_stream: turbo_stream.replace("status_badge_#{@shared_project.id}", partial: 'shared_projects/status_badge', locals: { shared_project: @shared_project }) }
    #     end
    #   else
    #     redirect_to freelancer_shared_projects_path, alert: 'There was an error accepting the project.'
    #   end
    # end

    def decline
      @shared_project = SharedProject.find(params[:id])
      if @shared_project.update(status: 'declined')
        respond_to do |format|
          format.html { redirect_to freelancer_shared_projects_path, notice: 'Project declined.' }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("status_badge_#{@shared_project.id}", partial: 'shared_projects/status_badge', locals: { shared_project: @shared_project }) }
        end
      else
        redirect_to freelancer_shared_projects_path, alert: 'There was an error declining the project.'
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
      params.require(:shared_project).permit(:name, :description, :project_id, :freelancer_id, :status)
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
