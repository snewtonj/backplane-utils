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

options = OpenStruct.new
options.realm = 'default'

OptionParser.new do |opts|
  
  opts.banner = "Usage: createclient2.rb [options]"

  opts.on("-r", "--realm REALM", "realm") do |r|
    options.realm = r
  end
  
  opts.on("-c", "--client CLIENT", "client id") do |u|
    options.userid = u
  end
  
  opts.on("-p", "--password PASSWORD", "client password") do |p|
    options.password = p
  end
  
  opts.on("-s", "--source-url SOURCEURL", "source url") do |s|
    options.sourceurl = s
  end
  
  opts.on("-d", "--redirect-uri REDIRECTURI", "redirect uri") do |r|
    options.redirecturi = r
  end
end.parse!


raise OptionParser::MissingArgument if (options.userid.nil? || options.password.nil? || options.sourceurl.nil? || options.redirecturi.nil?)

if (config[options.realm].nil?)
  puts "No such realm #{options.realm}"
  exit
end

settings = config[options.realm]

req = BP2::ProvisionRequest.new(settings[:adminid], settings[:adminpass], settings[:host])

busowner = BP2::ClientConfig.new(options.userid, options.password, options.sourceurl, options.redirecturi)

req.configs.push busowner

resp = doPost(req, "/v2/provision/client/update");

if !resp.hasError
  pp resp.body
else
  puts "Error #{resp.code}: #{resp.message}"
end
