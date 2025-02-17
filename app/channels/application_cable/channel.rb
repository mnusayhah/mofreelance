class DiscussionChannel < ApplicationCable::Channel
  def subscribed
    discussion = Discussion.find(params[:discussion_id])
    stream_for discussion
  end
end
