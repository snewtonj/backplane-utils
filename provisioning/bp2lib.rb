require 'json'
require 'net/https'

module BP2
  class PostRequest
    
    def initialize(verifyssl = true)
      if (!verifyssl)
        STDERR.puts("*** WARNING: INSECURE SSL CERTIFICATE VERIFY DISABLED")
        @verifymode = OpenSSL::SSL::VERIFY_NONE
      else
        @verifymode = OpenSSL::SSL::VERIFY_PEER
      end
    end
    
    def doPost(request, path)
      http = Net::HTTP.new(request.hostname, 443)
      http.verify_mode = @verifymode
      http.use_ssl = true
      post = Net::HTTP::Post.new(path, initheader= {'Content-Type' =>'application/json'})
      post.body = request.to_json
      response = http.start {|http| http.request(post) }
      return Response.new(response.code, response.message, response.body)
    end  
  end

  class Response
    attr_reader(:code, :message, :body)
  
    def initialize(code, message, body)
      @code = code
      @message = message
      @body = body
    end
  
    def hasError
      return code.to_i != 200
    end
  end
  
  class ProvisionListRequest
    attr_reader(:admin, :secret, :hostname, :entities)
  
    def initialize(adminid, secret, hostname, entities = [])
      @admin = adminid
      @secret = secret
      @hostname = hostname
      @entities = entities
    end
  
    def addEntity(entry)
      @entities.push entry
    end
    
    def to_json(*a)
      {
         :admin => @admin,
         :secret => @secret,
         :entities => @entities,
      }.to_json(*a)
    end
  end
  
  class ProvisionRequest
    attr_reader(:admin, :secret, :hostname, :configs)
  
    def initialize(adminid, secret, hostname)
      @admin = adminid
      @secret = secret
      @hostname = hostname
      @configs = []
    end
  
    def to_json(*a)
      {
         :admin => @admin,
         :secret => @secret,
         :configs => @configs,
      }.to_json(*a)
    end
  end
  
  class GrantRequest
    attr_reader(:admin, :secret, :hostname, :grants)
  
    def initialize(adminid, secret, hostname, grants)
      @admin = adminid
      @secret = secret
      @hostname = hostname
      @grants = grants 
    end
  
    def to_json(*a)
      {
         :admin => @admin,
         :secret => @secret,
         :grants => @grants,
      }.to_json(*a)
    end
  end
  class BusOwnerConfig
    attr_reader(:userid, :password)
  
    def initialize(userid, password)
      @userid = userid
      @password = password
    end
  
    def to_json(*a)
      {
         :USER => @userid,
         :PWDHASH => @password,
      }.to_json(*a)
    end
  end
  
  class ClientConfig
    attr_reader(:userid, :password, :sourceURL, :redirectURI)
  
    def initialize(userid, password, sourceURL, redirectURI)
      @userid = userid
      @password = password
      @sourceURL = sourceURL
      @redirectURI = redirectURI
    end
  
    def to_json(*a)
      {
         :USER => @userid,
         :PWDHASH => @password,
         :SOURCE_URL => @sourceURL,
         :REDIRECT_URI => @redirectURI,
      }.to_json(*a)
    end
  end
  
  class Bus
    attr_reader(:name, :owner, :retentionTime, :stickyTime)
  
    def self.build(name, owner)
      return Bus.new(name, owner, 28800, 28800)
    end
  
    def initialize(name, owner, retentionTime, stickyTime)
      @name = name
      @owner = owner
      @retentionTime = retentionTime
      @stickyTime = stickyTime
    end
  
    def to_json(*a)
      {
        :BUS_NAME => @name,
        :OWNER => @owner,
        :RETENTION_TIME_SECONDS => @retentionTime,
        :RETENTION_STICKY_TIME_SECONDS => @stickyTime
      }.to_json(*a)
    end
  end
  
  class Grant
    attr_reader(:clientname, :busname)
  
    def initialize(client, bus)
      @clientname = client
      @busname = bus
    end
  
    def to_json(*a)
      {
        :BUS_NAME => @busname,
        :CLIENT => @clientname,
      }.to_json(*a)
    end
  end
  
end