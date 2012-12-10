require 'net/https'
require 'response'

module Backplane
class Client
  attr_accessor(:host, :port, :bus, :channel)

  def initialize(host, port=80)
    @host = host
    @bus = bus
  end

  def postMessage(message, token) 
    http = Net::HTTP.new(@host, 443)
    http.use_ssl = true
    req = Net::HTTP::Post.new("/v2/message", initheader= {'Content-Type' =>'application/json', 'Authorization' => "Bearer #{token.access_token}"})
    wrappedMessage = { "message" => message }
    req.body = wrappedMessage.to_json
    response = http.start {|http| http.request(req) }
    return Response.new(response.code, response.message, response.body)
  end

  def getMessages(token)
    http = Net::HTTP.new(@host, 443)
    http.use_ssl = true
    req = Net::HTTP::Get.new("/v2/messages", initheader = {'Content-Type' =>'application/json', 'Authorization' => "Bearer #{token.access_token}"})
    response = http.start {|http| http.request(req) }
    return Response.new(response.code, response.message, response.body)
  end

  def getSingleMessage(token, id)
    http = Net::HTTP.new(@host, 443)
    http.use_ssl = true
    req = Net::HTTP::Get.new("/v2/message/#{id}", initheader = {'Content-Type' =>'application/json', 'Authorization' => "Bearer #{token.access_token}"})
    response = http.start {|http| http.request(req) }
    return Response.new(response.code, response.message, response.body)
  end

end
end
