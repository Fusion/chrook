require "duktape/runtime"

module Language extend self
  def execute(@@context, text, options = {} of String => String)
    context = @@context.not_nil!
    begin
      if options.has_key? "timeout"
        rt = Duktape::Runtime.new (options["timeout"].to_i) do |parser|
          parser.not_nil!.eval! "function run_it(env) { #{text} }"
        end
        Normalizer.rewrap rt.call "run_it", context.variables.raw
      else
        rt = Duktape::Runtime.new do |parser|
          parser.not_nil!.eval! "function run_it(env) { #{text} }"
        end
        Normalizer.rewrap rt.call "run_it", context.variables.raw
      end
    rescue ex
      abort "Invalid script found while executing", ex
    end
  end

  # TODO At this point, only one level deep. Not good.
  def convert(st)
    case st
    when CrArray
      converted = [] of YAML::Type | Float64 | Bool
      st.each do |row|
        converted.push convert row
      end
      converted
    when CrHash
      converted = {} of YAML::Type => YAML::Type | Float64 | Bool
      st.each do |k, v|
        #converted[k] = convert v
      end
      converted
    when Hash(YAML::Type, Duktape::JSPrimitive)
      abort "Woops!"
    when String
      st as String
    when Float64
      st as Float64
    when Bool
      st as Bool
    else
      "" as String
    end
  end
end
