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
  
  opts.on("-b", "--busname BUSNAME", "bus name") do |b|
    @busname = b
  end
  
  opts.on("-u", "--userid USERID", "bus user") do |u|
    @bususer = u
  end
end

options.parse!

raise OptionParser::MissingArgument if (@busname.nil? || @bususer.nil?)

if (config[realm].nil?)
  puts "No such realm #{realm}"
  exit
end

settings = config[realm]

req = BP::ProvisionRequest.new(settings[:adminid], settings[:adminpass], settings[:host])

bus = BP::Bus.build(@busname,@bususer)

req.configs.push bus

post = BP::PostRequest.new(settings[:sslverify])
resp = post.doPost(req, "/v1.2/provision/bus/update");

if !resp.hasError
  pp resp.body
else
  puts "Error #{resp.code}: #{resp.message}"
end
