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
end
