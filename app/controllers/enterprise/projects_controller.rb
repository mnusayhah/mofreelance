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

    if @project.save
      redirect_to user_project_path(current_user, @project), notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def show
    @project = current_user.projects.find(params[:id])
  end

  def edit
    # already handled
  end

  def update
    if @project.update(project_params)
      redirect_to user_project_path(current_user, @project), notice: 'Project was successfully updated.'
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
  def ongoing
    @projects = current_user.projects.ongoing
    render partial: "projects/list", locals: { projects: @projects }
  end

  def archived
    @projects = current_user.projects.archived
    render partial: "projects_table", locals: { projects: @projects }
  end

  def share
    @project = Project.find(params[:id])
    @freelancer = User.find(params[:user_id])
    @project.shared_projects.create(user: @freelancer)

    redirect_to company_dashboard_path, notice: 'Project shared successfully.'
  end

  def destroy
    @project.destroy
    redirect_to user_projects_path(current_user), notice: 'Project was successfully deleted.'
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id]) 
  end

  def project_params
    params.require(:project).permit(:title, :description, :budget, :required_skills, :visibility, :start_date, :end_date)
  end
end
