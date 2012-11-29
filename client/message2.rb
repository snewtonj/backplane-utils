module Backplane
class Message 
  attr_reader(:bus, :channel, :type, :sticky, :payload)

  def initialize(bus, channel, type, payload, sticky=false)
    @bus = bus
    @channel = channel
    @type = type
    @sticky = sticky
    @payload = payload
  end

  def to_json(*a)
    {
       :bus => @bus,
       :channel => @channel,
       :type => @type,
       :sticky => @sticky,
       :payload => @payload
    }.to_json(*a)
  end
end
end
