class Context
  getter hosts, variables, runners
  property persona, script_file

  def initialize
    @variables = Variables.new
    @runners = Runners.new
    @hosts = [] of YAML::Type

    @variables.context = self
    @runners.context = self

    @persona = nil
    @script_file = nil
  end

  def hosts=(text)
    @hosts = (Extrapolator.parse self, text) as Array(YAML::Type)
    @variables.set "hosts", @hosts
  end

  def script_path
    File.dirname @script_file.not_nil!
  end

  def file_name(file)
    script_path + "/" + file
  end

  def cleanup
    @runners.cleanup
  end
end
