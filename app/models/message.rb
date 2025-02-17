class Message < ApplicationRecord
  belongs_to :discussion
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  after_create_commit do
    broadcast_append_to discussion
  end

  after_create_commit do
    DiscussionChannel.broadcast_to(discussion,
      turbo_stream.append("messages", partial: "messages/message", locals: { message: self })
    )
  end


end
