module Freelancer
  class EducationsController < ApplicationController
    before_action :set_profile
    before_action :set_education, only: [:edit, :update, :destroy]
    before_action :authenticate_user!

    # GET /profiles/:profile_id/educations
    def index
      @educations = @profile.educations
    end

    # GET /profiles/:profile_id/educations/new
    def new
      @education = @profile.educations.build
    end

    # POST /profiles/:profile_id/educations
    def create
      @education = @profile.educations.build(education_params)
      if @education.save
        redirect_to profile_educations_path(@profile), notice: 'Education added successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # GET /profiles/:profile_id/educations/:id/edit
    def edit
    end

    # PATCH/PUT /profiles/:profile_id/educations/:id
    def update
      if @education.update(education_params)
        redirect_to profile_educations_path(@profile), notice: 'Education updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /profiles/:profile_id/educations/:id
    def destroy
      @education.destroy
      redirect_to profile_educations_path(@profile), notice: 'Education deleted successfully.'
    end

    private

    # Find the profile based on profile_id
    def set_profile
      @profile = Profile.find(params[:profile_id])
    end

    # Find the education based on id
    def set_education
      @education = @profile.educations.find(params[:id])
    end

    def education_params
      params.require(:education).permit(:school, :diploma, :start_date, :end_date, :localisation)
    end
  end
end
