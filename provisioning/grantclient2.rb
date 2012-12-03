#!/usr/bin/ruby

require 'optparse'
require 'pp'
require 'yaml'
require 'bp2lib'

config = begin
  YAML.load(File.open("#{ENV['HOME']}/.bprc"))
rescue ArgumentError => e
  puts "Unable to open .bprc : #{e.message}"
end

options = OpenStruct.new

options.realm = 'default'

OptionParser.new do |opts|
  opts.on("-r", "--realm REALM", "realm") do |r|
    options.realm = r
  end

  opts.on("-c", "--client CLIENT", "client id") do |c|
    options.client = c
  end

  opts.on("-b", "--bus BUS", "bus") do |b|
    options.bus = b
  end
end.parse!

raise OptionParser::MissingArgument if (options.client.nil? || options.bus.nil?)

if (config[options.realm].nil?)
  puts "No such realm #{options.realm}"
  exit
end

settings = config[options.realm]

grant = { options.client =>  options.bus }

req = BP2::GrantRequest.new(settings[:adminid], settings[:adminpass], settings[:host], grant)

post = BP2::PostRequest.new(settings[:sslverify])

resp = post.doPost(req, "/v2/provision/grant/add");

if !resp.hasError
  jj JSON.parse(resp.body)
else
  puts "Error #{resp.code}: #{resp.message}"
end
