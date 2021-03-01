class MicropostChannel < ApplicationCable::Channel
  def subscribed
    stream_from "micropost_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
