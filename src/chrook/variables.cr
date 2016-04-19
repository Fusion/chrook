class Variables
  def initialize
    @raw = {} of YAML::Type => Array(Duktape::JSPrimitive) | Array(YAML::Type) | Bool | Float64 | Hash(String, Duktape::JSPrimitive) | Hash(YAML::Type, YAML::Type) | String | Nil
  end

  def context=(context)
    @context = context
  end

  def set(k, v)
    @raw[k] = Extrapolator.parse @context, Raw.new v
  end

  def get(k)
    return @raw[k] if @raw.has_key?(k)
    nil
  end
end
