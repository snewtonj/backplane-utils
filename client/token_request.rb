require 'net/https'

module Backplane
class TokenRequest
  attr_reader(:credentials, :scope, :grant_type, :host, :port, :response_code)

  def initialize(credentials)
    @credentials = credentials
    @port = 80
  end

  def getToken(grant_type, scope)
    # puts "getToken call #{credentials} #{grant_type}: #{scope}"
    http = Net::HTTP.new(@credentials.hostname, 443)
    http.use_ssl = true
    path = "/v2/token"
    req = Net::HTTP::Post.new(path)
    req.basic_auth credentials.user, credentials.password
    req.set_form_data( 'grant_type' => grant_type, 'scope' => scope )
    response = http.start {|http| http.request(req) }
    # puts "getToken response #{response.code} #{response.message}: #{response.body}"
    @response_code = response.code
    response.body
   end

   def getRegularToken(bus)
    # puts "getRegularToken call #{@credentials} #{bus}"
    http = Net::HTTP.new(@credentials.hostname, 443)
    http.use_ssl = true
    path = "/v2/token?callback=f&bus=#{bus}"
    req = Net::HTTP::Get.new(path)
    #puts http.inspect
    response = http.start {|http| http.request(req) }
    # puts "getRegularToken response #{response.code} #{response.message}: #{response.body}"
    @response_code = response.code
    # trim off my callback
    response.body[2..-3]
   end
end
end
