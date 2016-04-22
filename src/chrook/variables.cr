class Variables
  alias RawVarType = Array(Duktape::JSPrimitive) | Array(YAML::Type) | Bool | Float64 | Hash(String, Duktape::JSPrimitive) | Hash(YAML::Type, YAML::Type) | String | Nil

  def initialize
    @raw = {} of YAML::Type => Hash(YAML::Type, RawVarType)
    @raw[":global"] = {} of YAML::Type => RawVarType
  end

  def context=(context)
    @context = context
  end

  def set(k, v, space=":global")
    @raw[space] = {} of YAML::Type => RawVarType if !@raw.has_key?(space)
    @raw[space][k] = Extrapolator.parse @context, Raw.new v
  end

  def get(k, space=":global")
    return nil if !@raw.has_key?(space)
    return nil if !@raw[space].has_key?(k)
    @raw[space][k]
  end

  def instance_set(instance, k, v)
    set k, v, instance
  end

  def instance_get(instance, k)
    get k, instance
  end

  def each_space(&block)
    @raw.each do |space, v|
      next if space == ":global"
      yield space, v
    end
  end
end
