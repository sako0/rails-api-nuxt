class PostCommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "post_comments_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
