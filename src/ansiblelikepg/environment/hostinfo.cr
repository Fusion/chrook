class HostInfo
  getter host

  def initialize(@host, @userinfo)
  end

  def username
    @userinfo.username
  end

  def password
    @userinfo.password
  end
end
