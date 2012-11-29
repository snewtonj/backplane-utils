module Backplane
class Message
  attr_reader(:source, :type, :sticky, :payload)

  def initialize(payload, source, type, sticky=false)
    @source = source
    @type = type
    @sticky = sticky
    @payload = payload
  end

  def to_json(*a)
    {
       :source => @source,
       :type => @type,
       :sticky => @sticky,
       :payload => payload
    }.to_json(*a)
  end
end
end
