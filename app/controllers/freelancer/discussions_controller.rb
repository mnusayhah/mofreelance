module Freelancer
  class DiscussionsController < ApplicationController
    def index
    end

    def show
      @discussion = Discussion.find(params[:id])
      @message = Message.new
    end
  end
end
