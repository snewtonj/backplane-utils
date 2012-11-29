module Backplane
class AccessToken
  attr_reader(:access_token, :refresh_token, :token_type, :expires_in, :scope, :scopes)

  def initialize(token_type, access_token, expires_in, scope, refresh_token)
    @token_type = token_type
    @access_token = access_token
    @expires_in = expires_in
    @scope = scope
    parseScope(@scope)
    @refresh_token = refresh_token
  end

  def initialize(h)
    @token_type = h['token_type']
    @access_token = h['access_token']
    @expires_in = h['expires_in']
    @scope = h['scope']
    parseScope(@scope)
    @refresh_token = h['refresh_token']
  end

  def parseScope(scopeString)
    @scopes = {}
    begin
      scope_pairs = scope.split(' ')
      scope_pairs.each { |pair| 
         h = Hash[*pair.split(':')]
         @scopes.update(h)
      }
    rescue
    end
  end

  def self.json_create(o)
    new(*o)
  end

  def to_json(*a)
    {
      'token_type' => @token_type,
      'access_token' => @access_token,
      'expires_in' => @expires_in,
      'scope' => @scope,
      'refresh_token' => @refresh_token
    }.to_json(*a)
  end
end
end
