#!/usr/bin/ruby
require 'backplane2'
require 'expayload'
require 'pp'
require 'user'
require 'yaml'

def writeToken(token, fileName)
  File.open(fileName, 'w') { |f|
    JSON.dump(token,f)
  }
end

def tokenFromFile(fileName)
  begin
    json = File.read(fileName)
    return Backplane::AccessToken.new(JSON.parse(json))
  rescue Errno::ENOENT => e
    return nil
  end
end

def loadRegularToken(host, bus)
  token = tokenFromFile("regular_token.json")
  if (token.nil?)
    req = Backplane::TokenRequest.new(host, 443)
    token = Backplane::AccessToken.new(JSON.parse(req.getRegularToken(bus)))
    writeToken(token, "regular_token.json")
  end
  token
end

def loadAuthenticatedToken(userid, password, host, bus)
  token = tokenFromFile("token.json")
  if (token.nil?)
    user = UserCredentials.new(userid, password)
    req = Backplane::TokenRequest.new(host, 443)
    token = Backplane::AccessToken.new(JSON.parse(req.getToken(user, 'client_credentials', "bus:#{bus}")))
    writeToken(token, "token.json")
  end
  token
end

config = begin
    YAML.load(File.open("#{ENV['HOME']}/.bprc"))
rescue ArgumentError => e
    puts "Unable to open .bprc : #{e.message}"
end

realm = 'default'

userid = config[realm][:userid]
password = config[realm][:password]
busname = config[realm][:busname]
host = config[realm][:host]

reg_token = loadRegularToken(host, busname)

token = loadAuthenticatedToken(userid, password, host, busname)

client = Backplane::Client.new(host, 443)

payload = ExamplePayload.new
# scope is bus:<busname> channel:<channel id>
scope_pairs = reg_token.scope.split(' ')
bus = scope_pairs[0].split(':')[1]
channel = scope_pairs[1].split(':')[1]
message = Backplane::Message.new(bus, channel, 'test', payload)
pp client.postMessage(message, token)
sleep 333.3/1000.0
response = client.getMessages(token)
pp response.body
