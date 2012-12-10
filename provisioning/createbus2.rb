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
  
  opts.on("-b", "--busname BUSNAME", "bus name") do |b|
    @busname = b
  end
  
  opts.on("-o", "--owner BUSOWNER", "bus owner") do |o|
    @busowner = o
  end
end

options.parse!

raise OptionParser::MissingArgument if (@busname.nil? || @busowner.nil?)

if (config[realm].nil?)
  puts "No such realm #{realm}"
  exit
end

settings = config[realm]

req = BP2::ProvisionRequest.new(settings[:adminid], settings[:adminpass], settings[:host])

bus = BP2::Bus.build(@busname, @busowner)

req.configs.push bus

resp = doPost(req, "/v2/provision/bus/update");

if !resp.hasError
  pp resp.body
else
  puts "Error #{resp.code}: #{resp.message}"
end
