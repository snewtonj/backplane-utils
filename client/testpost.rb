#!/usr/bin/ruby
require 'backplane'
require 'expayload'
require 'optparse'
require 'pp'
require 'user'
require 'yaml'

config = begin
    YAML.load(File.open("#{ENV['HOME']}/.bprc"))
rescue ArgumentError => e
    puts "Unable to open .bprc : #{e.message}"
end 

realm = 'default'

OptionParser.new do |opts|
  opts.on("-r", "--realm REALM", "realm") do |r|
    realm = r
  end
end.parse!

userid = config[realm][:userid]
password = config[realm][:password]
busname = config[realm][:busname]
host = config[realm][:host]

user = UserCredentials.new(userid, password)

client = Backplane::Client.new(host, busname)

puts "Got channel #{client.requestChannel}"

payload = ExamplePayload.new
message = Backplane::Message.new(payload, "http://janrain.com", "test")
puts client.postMessage(message, user)
sleep 333.3/1000.0
response = client.getChannelMessages(user)
pp response.body
