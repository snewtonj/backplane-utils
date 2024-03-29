#!/usr/bin/ruby

require 'net/https'
require 'optparse'
require 'pp'
require 'yaml'

require 'bplib'

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

req = BP::ProvisionRequest.new(settings[:adminid], settings[:adminpass], settings[:host])

user = BP::UserConfig.new(@userid,@password)

req.configs.push user

post = BP::PostRequest.new(settings[:sslverify])
resp = post.doPost(req, "/v1.2/provision/user/update");

if !resp.hasError
  pp resp.body
else
  puts "Error #{resp.code}: #{resp.message}"
end
