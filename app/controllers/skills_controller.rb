class SkillsController < ApplicationController
  before_action :set_profile
  before_action :set_skill, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /profiles/:profile_id/skills
  def index
    @skills = @profile.skills
  end

  # GET /profiles/:profile_id/skills/new
  def new
    @skill = @profile.skills.build
  end

  # POST /profiles/:profile_id/skills
  def create
    @skill = @profile.skills.build(skill_params)
    if @skill.save
      redirect_to profile_skills_path(@profile), notice: 'Skill created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /profiles/:profile_id/skills/:id/edit
  def edit
  end

  # PATCH/PUT /profiles/:profile_id/skills/:id
  def update
    if @skill.update(skill_params)
      redirect_to profile_skills_path(@profile), notice: 'Skill updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/:profile_id/skills/:id
  def destroy
    @skill.destroy
    redirect_to profile_skills_path(@profile), notice: 'Skill deleted successfully.'
  end

  private

  # Find the profile based on profile_id
  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  # Find the skill based on id
  def set_skill
    @skill = @profile.skills.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:job_title, :company, :start_date, :end_date, :description, :localisation)
  end
end
