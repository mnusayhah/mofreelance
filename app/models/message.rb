class Message < ApplicationRecord
  belongs_to :discussion
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  # after_create_commit { broadcast_append_to "discussion_#{discussion.id}" }

  # after_create_commit do
  #   DiscussionChannel.broadcast_to(discussion,
  #     turbo_stream.append("messages", partial: "messages/message", locals: { message: self })
  #   )
  # end


end
