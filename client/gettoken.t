require 'backplane'
require 'json'
require 'token'
require 'token_request'
require 'user'
require 'pp'

user = UserCredentials.new("steven", "gojanrain")
req = TokenRequest.new("bp-dev.janrain.com", 443)
token = AccessToken.new(JSON.parse(req.getToken(user, 'client_credentials', 'bus:steven-dev')))
p token.access_token
reg_token = AccessToken.new(JSON.parse(req.getRegularToken('steven-dev-bus.janrain.com')))
pp reg_token
