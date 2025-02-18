module Freelancer
  class DiscussionsController < ApplicationController
    def index
    end

    def show
      @discussion = Discussion.find(params[:id])
      @messages = @discussion.messages.includes(:sender, :receiver)
    end
  end
end
