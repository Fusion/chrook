class HostInfo

  def initialize(host)
    @hostname = host["name"]
    @driver   = host["driver"]
    @address  = host["address"]

    @userinfo = UserInfo.new host["user"], host["pass"]
  end

  def initialize(host, @userinfo)
  end

  def hostname
    @hostname as String
  end

  def driver
    @driver as String
  end

  def address
    @address as String
  end

  def username
    @userinfo.username
  end

  def password
    @userinfo.password
  end
end
