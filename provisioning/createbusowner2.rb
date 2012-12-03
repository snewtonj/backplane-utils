#!/usr/bin/ruby

require 'net/https'
require 'optparse'
require 'pp'
require 'yaml'

require 'bp2lib'

def doPost(request, path)
  http = Net::HTTP.new(request.hostname, 443)
  http.use_ssl = true
  post = Net::HTTP::Post.new(path, initheader= {'Content-Type' =>'application/json'})
  post.body = request.to_json
  response = http.start {|http| http.request(post) }
  return BP2::Response.new(response.code, response.message, response.body)
end

config = begin
    YAML.load(File.open("#{ENV['HOME']}/.bprc"))
rescue ArgumentError => e
    puts "Unable to open .bprc : #{e.message}"
end

realm = 'default'

options = OptionParser.new do |opts|
  opts.on("-r", "--realm REALM", "realm") do |r|
    realm = r
  end
  
  opts.on("-u", "--userid USERID", "bus owner id") do |u|
    @userid = u
  end
  
  opts.on("-p", "--password PASSWORD", "bus owner password") do |p|
    @password = p
  end
end

options.parse!

raise OptionParser::MissingArgument if (@userid.nil? || @password.nil?)

if (config[realm].nil?)
  puts "No such realm #{realm}"
  exit
end

settings = config[realm]

req = BP2::ProvisionRequest.new(settings[:adminid], settings[:adminpass], settings[:host])

busowner = BP2::BusOwnerConfig.new(@userid,@password)

req.configs.push busowner

resp = doPost(req, "/v2/provision/user/update");

if !resp.hasError
  pp resp.body
else
  puts "Error #{resp.code}: #{resp.message}"
end
