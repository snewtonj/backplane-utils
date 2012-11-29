module Backplane
class MessageFrame
  attr_accessor(:message, :channel_name, :id)

  def initialize(message, channel_name, id)
    @message = message
    @channel_name = channel_name
    @id = id
  end
end
end
