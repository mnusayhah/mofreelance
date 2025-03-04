module Enterprise
  class Enterprise::ProfilesController < ApplicationController
    # before_action :set_project

    # def new
    #   @profile = @project.build_profile
    # end

    # def create
    #   @profile = @project.build_profile(profile_params)
    #   if @profile.save
    #     redirect_to enterprise_project_path(@project), notice: 'Profile was successfully created.'
    #   else
    #     render :new
    #   end
    # end

    # private

    # def set_project
    #   @project = Project.find(params[:project_id])
    # end

    # def profile_params
    #   params.require(:profile).permit(:name, :description) # Add more fields as needed
    # end
  end
end
