module Freelancer
  class DiscussionsController < ApplicationController
    def index
    end

    def show
      @discussion = Discussion.find(params[:id])
      @messages = @discussion.messages.includes(:sender, :receiver)

      if current_user.freelancer?
        render "freelancer/discussions/show"
      else
        render "enterprise/discussions/show"
      end
    end


    private
    def discussion_params
      params.require(:discussion).permit(:project_id, :enterprise_id, :freelancer_id)
    end
  end
end
