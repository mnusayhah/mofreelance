module Enterprise
  class ProjectsController < ApplicationController
    before_action :authenticate_user!

    before_action :set_project, only: [:show, :edit, :update, :destroy]

    def index
      if params[:status].present?
        # Assuming status is an array (e.g., ['open', 'pending']) or a single status
        @projects = Project.where(status: params[:status])
      else
        @projects = Project.all
      end
    end

    def new
      @project = current_user.projects.build
    end

    def create
      @project = current_user.projects.build(project_params)
      #@project.status = 0
      if @project.save
        respond_to do |format|
          format.html { redirect_to enterprise_projects_path, notice: "Project created successfully." }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("projects_frame", partial: "projects_list", locals: { shared_projects: @projects }) }
        end
        # redirect_to enterprise_projects_path(current_user), notice: 'Project was successfully created.'
      else
        render :new
      end
    end

    def show
    end

    def edit
      @project = Project.find(params[:id])
    end

    def update
      @project = Project.find(params[:id])
      if @project.update(project_params)
        respond_to do |format|
          format.html { redirect_to enterprise_projects_path(current_user), notice: 'Project was successfully updated.' }
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("projects_frame", template: "enterprise/projects/show", locals: { project: @project })
          end
        end
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

      if @project.update(status: "paid")
        redirect_to enterprise_project_path(@project), notice: "Project marked as paid."
      else
        redirect_to enterprise_project_path(@project), alert: "Failed to mark project as paid."
      end

      # @project = Project.find(params[:id])

      # if @project.update(status: :paid)
      #   # Once marked as paid, the company can then mark it as completed
      #   redirect_to @project, notice: "Project marked as paid!"
      # else
      #   # Handle failure
      # end
    end

    # Then, to mark as completed:
    def mark_as_completed
        # if @project.update(status: "completed")
        #   respond_to do |format|
        #     format.html { redirect_to enterprise_dashboard_path, notice: "Project completed successfully!" }
        #     format.turbo_stream
        #   end
        # else
        #   flash[:alert] = "Failed to complete the project."
        # end
      @project = Project.find(params[:id])

      if @project.status == 'paid' # Ensure it can only be completed after paid
        @project.update(status: 'completed')
        redirect_to enterprise_project_path(@project), notice: "Project marked as completed!"
      else
        redirect_to enterprise_project_path(@project), alert: "Project must be marked as paid before completing."
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
      @project = Project.find(params[:id])
      @project.destroy

      respond_to do |format|
        format.html { redirect_to enterprise_projects_path(current_user), notice: 'Project was successfully deleted.' }
        format.turbo_stream { render turbo_stream: turbo_stream.remove("project_#{@project.id}") }
      end
    end

    private

    def set_project
      @project = Project.find_by(id: params[:id]) # Use find_by to avoid exceptions if not found
      if @project.nil?
        redirect_to enterprise_projects_path, alert: "No project found."
      end
    end

    def project_params
      params.require(:project).permit(:title, :description, :budget, :required_skills,:logo, :visibility, :start_date, :end_date, :status)
    end
  end
end
