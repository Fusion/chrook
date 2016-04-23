module Normalizer extend self
  # From duktape.cr/src/duktape/runtime.cr
  alias JSPrimitive = Nil | Float64 | String | Bool | Array(JSPrimitive) | Hash(String, JSPrimitive)

  # Pass an object; object is returned in its most primitive form
  def rewrap(obj)
    rewrap_ obj
  end

  def rewrap_(obj) : YAML::Type
    case obj
    when Array(Duktape::JSPrimitive)
      newo = [] of YAML::Type
      obj.each do |row|
        newo.push rewrap_ row
      end
      newo
    when Hash(String, Duktape::JSPrimitive)
      newo = {} of YAML::Type => YAML::Type
      obj.each do |k, v|
        newo[k] = rewrap_ v
      end
      newo
    when Hash(YAML::Type, Array(Duktape::JSPrimitive))
      newo = {} of YAML::Type => YAML::Type
      obj.each do |k, v|
        newo[k] = rewrap_ v
      end
      newo
    when Bool
      "Bool" as YAML::Type
    when Float64
      "Float64" as YAML::Type
    when String
      obj as YAML::Type
    when Nil
      "Nil" as YAML::Type
    else
      obj as YAML::Type
    end
  end
end
