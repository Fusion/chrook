module Extrapolator extend self

  def parse(@@context, text)
    parse_ text.raw
  end

  def parse_(raw_text)
    case raw_text
    when String
      text = var_exp_literal raw_text
      return text if text.size < 4
      if text[0] == '@' && text[2] == ':'
        arguments, payload = text[3..-1].split /\n/, 2
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
        expanded.push parse_ row
      end
      expanded
    when Hash(YAML::Type, YAML::Type)
      expanded = {} of YAML::Type => YAML::Type
      raw_text.each do |k, v|
        expanded[k] = parse_ v
      end
      expanded
    when Array(Duktape::JSPrimitive)
      expanded = [] of YAML::Type
      raw_text.each do |row|
        expanded.push parse_ row
      end
      expanded
    when Hash(String, Duktape::JSPrimitive)
      expanded = {} of YAML::Type => YAML::Type
      raw_text.each do |k, v|
        expanded[k] = parse_ v
      end
      expanded
    else
      abort "Unable to extrapolate type #{typeof(raw_text)}"
    end
  end

  def var_exp_literal(text)
    text.gsub(/{{.+?}}/) do |match|
      @@context.not_nil!.variables.get match[2...-2]
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

end
