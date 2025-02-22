module Freelancer
    class MessagesController < ApplicationController
    before_action :authenticate_user!

    def create
      @discussion = Discussion.find(params[:discussion_id])

      if @discussion.nil?
        redirect_to freelancer_dashboard_path, alert: "Discussion not found."
        return
      end

      @message = @discussion.messages.build(message_params)
      @message.receiver = current_user

      if @message.save
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to discussion_path(@discussion) }
        end
      else
        render "freelancer/discussions/show", status: :unprocessable_entity
      end
    end

    private

    def message_params
      params.require(:message).permit(:content, :sender_id, :receiver_id, :discussion_id, :read)
    end
  end
end
