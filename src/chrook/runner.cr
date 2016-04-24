abstract class Runner
  def initialize(@hostinfo)
  end

  def hostname
    @hostinfo.hostname
  end
end
