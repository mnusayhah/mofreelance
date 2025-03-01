module Enterprise
  class ProjectsController < ApplicationController
    before_action :authenticate_user!

    before_action :set_project, only: [:show, :edit, :update, :destroy]

    def index
      @projects = current_user.projects
    end

    def new
      @project = current_user.projects.build
    end

    def create
      @project = current_user.projects.build(project_params)
      #@project.status = 0
      if @project.save
        redirect_to enterprise_projects_path(current_user), notice: 'Project was successfully created.'
      else
        render :new
      end
    end

    def show
    end

    def edit
      # already handled
    end

    def update
      if @project.update(project_params)
        redirect_to enterprise_projects_path(current_user, @project), notice: 'Project was successfully updated.'
      else
        render :edit
      end
    end

    def my_projects
      @my_projects = current_user.projects
      render partial: "projects_table"
    end

    #def ongoing
      #@projects = current_user.projects.ongoing  # Fetch ongoing projects
      #render partial: "projects_table", locals: { projects: @projects }  # Render only the table with projects
    #end
    #def ongoing
      #@projects = current_user.projects.ongoing
      #render partial: "projects/list", locals: { projects: @projects }
    #end

    #def archived
      #@projects = current_user.projects.archived
      #render partial: "projects_table", locals: { projects: @projects }
    #end

    def mark_as_paid
      @project = Project.find(params[:id])

      if @project.update(status: :paid)
        # Once marked as paid, the company can then mark it as completed
        redirect_to @project, notice: "Project marked as paid!"
      else
        # Handle failure
      end
    end

    # Then, to mark as completed:
    def mark_as_completed
      @project = Project.find(params[:id])

      if @project.status == 'paid' # Ensure it can only be completed after paid
        @project.update(status: :completed, completed_at: Time.current)
        redirect_to @project, notice: "Project marked as completed!"
      else
        redirect_to @project, alert: "Project must be marked as paid before completing."
      end
    end

    def share
      @project = Project.find(params[:project_id])
      profile = Profile.find(params[:profile_id])
      freelancer = profile.user_id
      shared_project = SharedProject.create(
        project_id: @project.id,
        freelancer_id: freelancer,
        status: 0
      )
      @project.status = 1

      if shared_project.save
        @project.save
        redirect_to enterprise_projects_path(@project.id), notice: 'Project successfully shared with freelancer.'
      else
        redirect_to enterprise_projects_path(current_user), alert: 'Failed to share the project.'
      end
    end

    def destroy
      @project.destroy
      redirect_to enterprise_projects_path(current_user), notice: 'Project was successfully deleted.'
    end

    private

    def set_project
      @project = Project.find_by(id: params[:id]) # Use find_by to avoid exceptions if not found
      if @project.nil?
        redirect_to projects_path, alert: "No project found."
      end
    end

    def project_params
      params.require(:project).permit(:title, :description, :budget, :required_skills, :visibility, :start_date, :end_date, :status)
    end
  end
end
