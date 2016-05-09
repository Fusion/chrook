abstract class Runner
  getter hostinfo

  def initialize(@hostinfo)
  end

  def hostname
    @hostinfo.hostname
  end
end
