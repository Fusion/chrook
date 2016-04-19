class Context
  getter hosts, variables, runners

  @hosts : Array(YAML::Type)|Array(Duktape::JSPrimitive)

  def initialize
    @variables = Variables.new
    @runners = Runners.new
    @hosts = [] of YAML::Type

    @variables.context = self
    @runners.context = self
  end

  def hosts=(text)
    @hosts = (Extrapolator.parse self, text) as Array(YAML::Type)|Array(Duktape::JSPrimitive)
  end
end
