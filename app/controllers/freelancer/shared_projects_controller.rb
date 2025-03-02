module Freelancer
  class SharedProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_freelancer!
    before_action :set_shared_project, only: [:accept, :decline, :mark_payment_received]
    before_action :authorize_freelancer!, only: [:accept, :decline, :mark_payment_received]


    def index
      @shared_projects = SharedProject.where(freelancer_id: current_user.id)
      @pending_projects = SharedProject.where(status: "pending")
      @accepted_projects = SharedProject.where(status: "accepted")
      @completed_projects = SharedProject.where(status: "completed")
      @declined_projects = SharedProject.where(status: "declined")

      if params[:status].present?
        if params[:status] == 'paid'
          # Fetch both 'paid' and 'completed' projects when the status is 'paid'
          @shared_projects = @shared_projects.where(status: ['paid', 'completed'])
        else
          # Filter by the given status (i.e., pending, accepted, etc.)
          @shared_projects = @shared_projects.where(status: params[:status])
        end
      end

      # respond_to do |format|
      #   format.turbo_stream { render partial: "projects_list", locals: { shared_projects: @shared_projects } }
      #   format.html # This handles full-page loads (fallback)
      # end

    end

    def ongoing_projects
      @shared_projects = SharedProject.where(freelancer_id: current_user.id, status: "accepted")
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
      if @shared_project.update(status: "accepted")
        respond_to do |format|
          format.html { redirect_to freelancer_dashboard_path, notice: "Project accepted successfully!" }
          format.turbo_stream
        end
      else
        flash[:alert] = "Failed to accept the project."
      end
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
      if @shared_project.update!(status: "declined")
        respond_to do |format|
          format.html { redirect_to freelancer_dashboard_path, notice: "Project declined!" }
          format.turbo_stream
        end
      else
        flash[:alert] = "Failed to decline the project."
      end
    end

    def update_project_and_shared_project_status_on_paid
      # If freelancer accepts the project, set project to ongoing
      if paid? && project.status != 'completed'
        project.update(status: :completed)
      end
    end

    def mark_payment_received
      @shared_project = SharedProject.find(params[:id])
      @project = @shared_project.project
      # Ensure that the project status is 'paid' before marking as completed
      if @shared_project.status == 'paid'
        @shared_project.update(status: 'completed')
        # Optionally, you can also update the related project status here if needed
        @shared_project.update_project_and_shared_project_status_on_paid
        @project.update_project_and_shared_project_status_on_paid

        respond_to do |format|
          format.turbo_stream {
            render turbo_stream: turbo_stream.replace("status_badge_#{@shared_project.id}",
                                                 partial: "freelancer/shared_projects/status_badge",
                                                 locals: { shared_project: @shared_project })
          }
          format.html { redirect_to freelancer_shared_projects_path(status: 'paid'), notice: "Payment received and project marked as completed!" }
        end
      else
        redirect_to freelancer_shared_projects_path, alert: "Project is not marked as paid."
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

    # def set_project
    #   @project = Project.find(params[:id])
    # end

    def authorize_freelancer!
      unless current_user.freelancer? && @shared_project.freelancer == current_user
        redirect_to root_path, alert: "You are not authorized to perform this action."
      end
    end

  end
end
