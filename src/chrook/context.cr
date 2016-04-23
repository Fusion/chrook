class Context
  getter hosts, variables, runners

  def initialize
    @variables = Variables.new
    @runners = Runners.new
    @hosts = [] of YAML::Type

    @variables.context = self
    @runners.context = self
  end

  def hosts=(text)
    @hosts = (Extrapolator.parse self, text) as Array(YAML::Type)
    @variables.set "hosts", @hosts
  end

  def cleanup
    @runners.cleanup
  end
end
