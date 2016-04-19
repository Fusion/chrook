module Extrapolator extend self

  def parse(@@context, text)
    parse_ text.raw
  end

  def parse_(raw_text)
    case raw_text
    when String
      text = var_exp_literal(raw_text)
      return text if text.size < 4
      if text[0] == '@' && text[2] == ':'
        arguments, payload = text[3..-1].split(/\n/, 2)
        case directive = text[1]
        when '#'
          return Language.execute @@context, payload, argd arguments
        when 'v'
          return var_exp_raw payload, argd arguments
        else
          abort "Unknown expansion directive: #{directive}"
        end
      end
      text
    when Nil
      nil
    when Array(YAML::Type)
      expanded = [] of YAML::Type
      raw_text.each do |row|
        expanded.push supported parse_ row
      end
      expanded
    when Hash(YAML::Type, YAML::Type)
      expanded = {} of YAML::Type => YAML::Type
      raw_text.each do |k, v|
        expanded[k] = supported parse_ v
      end
      expanded
    else
      abort "Unable to extrapolate type #{typeof(raw_text)}"
    end
  end

  def var_exp_literal(text)
    text.gsub(/{{.+?}}/) do |match|
      @@context.not_nil!.variables.get(match[2...-2])
    end
  end

  def var_exp_raw(text, args)
    @@context.not_nil!.variables.get text.strip
  end

  def argd(text)
    args = {} of String => String
    return args if text == ""
    text[0...-1].split(' ').each do |row|
      k, v = row.split '='
      args[k] = v
    end
    args
  end

  def supported(parsed)
    case parsed
    when Array(YAML::Type)
      parsed as Array(YAML::Type)
    when Hash(YAML::Type, YAML::Type)
      parsed as Hash(YAML::Type, YAML::Type)
    when String
      parsed as String
    when Nil
      nil
    else
      begin
        sup = [] of YAML::Type
        (parsed as Array).each do |row|
          sup.push(row as YAML::Type)
        end
        sup
      rescue ex
        begin
          sup = {} of YAML::Type => YAML::Type
          (parsed as Hash).each do |k, v|
            sup[k] = v as YAML::Type
          end
          sup
        rescue ex
          abort "Unsupported type returned to extrapolator: #{dump_type parsed}"
        end
      end
    end
  end

# YAML::Type = Array(YAML::Type), Hash(YAML::Type, YAML::Type), String, Nil
# Thus: (Array(Duktape::JSPrimitive) | Array(YAML::Type) | Bool | Float64 | Hash(String, Duktape::JSPrimitive) | Hash(YAML::Type, YAML::Type) | String | Nil)
# == YAML::Type | Array(Duktape::JSPrimitive) | Bool | Float64 | Hash(String, Duktape::JSPrimitive)
  def dump_type(parsed)
    case parsed
    when Array(Duktape::JSPrimitive)
      "JSPrimitive"
    when Array(YAML::Type)
      "YAML::Type"
    when Bool
      "Bool"
    when Float64
      "Float64"
    when Hash(YAML::Type, YAML::Type)
      "Hash(YAML::Type, YAML::Type)"
    when Hash(YAML::Type, Duktape::JSPrimitive)
      "Hash(YAML::Type, Duktape::JSPrimitive)"
    when Hash(YAML::Type, Array(Duktape::JSPrimitive))
      "Hash(YAML::Type, Array(Duktape::JSPrimitive))"
    when Hash(YAML::Type, Hash(String, Duktape::JSPrimitive))
      "Hash(YAML::Type, Hash(String, Duktape::JSPrimitive))"
    when Hash(YAML::Type, Bool)
      "Hash(YAML::Type, Bool)"
    when Hash(YAML::Type, Float64)
      "Hash(YAML::Type, Float64)"
    when Hash(String, String)
      "Hash(String, String)"
    when Hash(String, YAML::Type)
      "Hash(String, YAML::Type)"
    when Hash(String, Duktape::JSPrimitive)
      "Hash(String, Duktape::JSPrimitive)"
    when Hash(String, Array(Duktape::JSPrimitive))
      "Hash(String, Array(Duktape::JSPrimitive))"
    when Hash(String, Hash(String, Duktape::JSPrimitive))
      "Hash(String, Hash(String, Duktape::JSPrimitive))"
    when Hash(String, Bool)
      "Hash(String, Bool)"
    when Hash(String, Float64)
      "Hash(String, Float64)"
    when Hash(String, String)
      "Hash(String, String)"
    when Hash
      "Hash<?, ?>"
    when String
      "String"
    when Nil
      "Nil"
    else
      "Unknown -- one of: #{typeof(parsed)}"
    end
  end
end
