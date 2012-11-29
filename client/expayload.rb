require 'json'
require 'uuid'

class ExamplePayload
  attr_reader(:uuid, :clientTimestamp)

  def initialize
    uuid_generator = UUID.new
    @uuid = uuid_generator.generate
    @clientTimestamp = Time.new.to_i
  end

  def to_json(*a)
    { :uuid => @uuid, :clientTimestamp => @clientTimestamp }.to_json(*a)
  end

  def to_s
    return "[clientTimestamp: "+clientTimestamp.to_s+" uuid: "+uuid+"]"
  end

end
