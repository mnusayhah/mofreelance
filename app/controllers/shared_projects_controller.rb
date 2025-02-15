class SharedProjectsController < ApplicationController
  before_action :authenticate_user!

  # GET /shared_projects
  def index
      # Get only shared projects where the current user is the freelancer
     @shared_projects = SharedProject.includes(:project).where(freelancer_id: current_user.id) || [] if current_user.freelancer?
  end

  # GET /shared_projects/new
  def new
    @shared_project = SharedProject.new
  end

  # GET /users/:user_id/shared_projects/:id
  def show
    @shared_project = SharedProject.find_by(id: params[:id], freelancer_id: current_user.id)

    # if @shared_project.nil?
    #   redirect_to user_shared_projects_path, alert: "Shared project not found or you don't have access."
    # end
  end

  # GET /shared_projects/:id/edit
  # def edit
  #   @shared_project = SharedProject.find(params[:id])
  # end

  # # PATCH/PUT /shared_projects/:id
  # def update
  #   @shared_project = SharedProject.find(params[:id])
  #   if @shared_project.update(shared_project_params)
  #     redirect_to shared_projects_path, notice: 'Shared project updated successfully.'
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  # DELETE /shared_projects/:id
  # def destroy
  #   @shared_project = SharedProject.find(params[:id])
  #   @shared_project.destroy
  #   redirect_to shared_projects_path, notice: 'Shared project deleted successfully.'
  # end

  private

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
      redirect_to shared_projects_path, alert: "Shared Project not found."
    end
  end

end
