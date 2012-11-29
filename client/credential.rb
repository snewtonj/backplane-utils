class UserCredentials
  attr_reader(:hostname, :user, :password)
  

  def initialize(hostname, user, password)
    @hostname = hostname
    @user = user
    @password = password
  end

  def to_s
    "[hostname: #{@hostname} user: #{@user} password: #{@password}]"
  end
end
