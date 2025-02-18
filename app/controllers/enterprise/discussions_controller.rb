module Enterprise
  class DiscussionsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_enterprise_role

    def show
        @discussion = Discussion.find(params[:id])
        @messages = @discussion.messages.includes(:sender, :receiver)
      end
    end


    def create
      @project = Project.find(params[:project_id])

      if @project.enterprise_id == current_user.id && @project.shared_projects.accepted.exists?
        @discussion = @project.discussion || @project.create_discussion

        redirect_to enterprise_discussion_path(@discussion)
      else
        redirect_to enterprise_dashboard_path, alert: "You cannot start a discussion for this project."
      end
    end

    private

    def ensure_enterprise_role
      redirect_to root_path, alert: "Access denied." unless current_user.enterprise?
    end
  end
end
