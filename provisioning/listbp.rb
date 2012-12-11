#!/usr/bin/ruby

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
entity = []
options = OptionParser.new do |opts|
  opts.on("-r", "--realm REALM", "realm") do |r|
    realm = r
  end
  
  opts.on("-t", "--type ENTITYTYPE", "entity type") do |t|
    @type = t
  end

  opts.on("-e", "--entity ENTITY", "entity") do |e|
    entity.push e
  end
end

options.parse!

if (config[realm].nil?)
  puts "No such realm #{realm}"
  exit
end

settings = config[realm]

req = BP::ProvisionListRequest.new(settings[:adminid], settings[:adminpass], settings[:host], entity)

post = BP::PostRequest.new(settings[:sslverify])
resp = post.doPost(req, "/v1.2/provision/#{@type}/list");

if !resp.hasError
  jj JSON.parse(resp.body)
else
  puts "Error #{resp.code}: #{resp.message}"
end
