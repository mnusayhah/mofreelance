module Enterprise
  class MessagesController < ApplicationController
    before_action :authenticate_user!

    def create
      @discussion = Discussion.find(params[:discussion_id])

      if @discussion.project.enterprise == current_user || @discussion.project.shared_projects.any? { |sp| sp.freelancer == current_user }
        @message = @discussion.messages.build(message_params)
        @message.sender = current_user

        if @message.save
          respond_to do |format|
            format.turbo_stream
            format.html { redirect_to enterprise_discussion_path(@discussion) }
          end
        else
          render "enterprise/discussions/show"
        end
      else
        redirect_to root_path, alert: "You are not authorized to send messages in this discussion."
      end
    end

    private

    def message_params
      params.require(:message).permit(:content, :sender_id, :receiver_id, :discussion_id, :read)
    end
  end
end
