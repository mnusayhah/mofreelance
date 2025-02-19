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
  end
end
