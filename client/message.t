require 'expayload'
require 'message'

payload = ExamplePayload.new
p payload.to_s
p payload.to_json

message = Message.new(payload, "http://janrain.com", "test")

puts message.to_json
