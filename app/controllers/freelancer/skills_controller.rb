module Freelancer
  class SkillsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile

      def new
        @skill = @profile.skills.build
        render partial: 'freelancer/skills/skill_form', locals: { profile: @profile, skill: @skill } # Pass profile and skill as locals
      end

      def create
          @skill = @profile.skills.build(skill_params)
          if @skill.save
              render json: { success: true }
          else
              render json: { success: false, errors: @skill.errors.full_messages }, status: :unprocessable_entity
          end
      end

      private

      def set_profile
          @profile = Freelancer::Profile.find(params[:profile_id])
      end

      def skill_params
          params.require(:skill).permit(:job_title, :description, :company, :start_date, :end_date)
      end
  end
end
