class Variables

  Global_Space = "$"
  getter raw

  def initialize
    @raw = {} of YAML::Type => Hash(YAML::Type, YAML::Type)
    @raw[Global_Space] = {} of YAML::Type => YAML::Type
  end

  def context=(context)
    @context = context
  end

  def set(k, v, space=Global_Space)
    @raw[space] = {} of YAML::Type => YAML::Type if !@raw.has_key? space
    @raw[space][k] = Extrapolator.parse @context, Raw.new v
  end

  def get(k, space=Global_Space)
    return nil if !@raw.has_key? space
    return nil if !@raw[space].has_key? k
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
      next if space == Global_Space
      yield space, v
    end
  end
end
