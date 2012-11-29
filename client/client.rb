require 'net/https'
require 'response'

module Backplane
class Client
  attr_accessor(:host, :port, :bus, :channel)

  def initialize(host, credentials, bus, port=80)
    @credentials = credentials
    @host = host
    @port = port
    @bus = bus
  end

  def requestChannel
    uri = URI("http://"+@host+":"+@port.to_s+"/v1.2/bus/"+@bus+"/channel/new")
    result = Net::HTTP.get(uri)
    @channel = result.gsub('"','')
  end

  def postMessage(message) 
    path = "/v1.2/bus/#{@bus}/channel/#{@channel}"
    req = Net::HTTP::Post.new(path, initheader = {'Content-Type' =>'application/json'})
    req.body = [message].to_json
    req.basic_auth @credentials.user, @credentials.password
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
    return Response.new(response.code, response.message, response.body)
  end

  def getChannelMessages()
    path = "/v1.2/bus/#{@bus}/channel/#{@channel}"
    req = Net::HTTP::Get.new(path)
    req.basic_auth @credentials.user, @credentials.password
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
    return Response.new(response.code, response.message, response.body)
  end

end
end
