require "yaml"
require "option_parser"
require "./chrook/*"
require "./chrook/environment/*"
require "./chrook/actions/*"

# DESIRED PLUGINS
# -ensure_file_exists
# -ensure_file_exists_and_is <file>
# -ensure_file_contains // will append
# -
#
# Let's first jump through some hoops to abstract out
# various types

def log_level
  3
end

def abort(cleartext, ex = nil)
  puts "Aborting: #{cleartext}"
  puts ex if ex != nil
  exit
end

def info(msg, prefix = "")
  puts "#{prefix}# #{msg}"
end

def log(level, prefix, msg)
  puts "[#{prefix}]: #{msg}" if level <= log_level
end

def log(level, prefix, hostname, msg)
  puts "[#{prefix}@#{hostname}]: #{msg}" if level <= log_level
end

def debug(*args)
  p args
end

def register_action(name : String, action : Class)
  @@registered_actions ||= {} of String => Action
  @@registered_actions.not_nil![name] = action.new
end

def get_action(name : String)
  nil if !@@registered_actions.not_nil!.has_key?(name)
  @@registered_actions.not_nil!.[name]
end

begin
  OptionParser.parse! do |parser|
    parser.banner = "Arguments: <file.yml>"
    parser.unknown_args do |arg|
      if arg.size < 1
        puts "Missing argument."
        exit -1
      end
      @@file_name = arg[0]
    end
  end
rescue ex: OptionParser::InvalidOption
  puts "#{ex}"
  exit -1
end

# TODO:40 we will need to use fibers
yepics = YAML.parse File.read @@file_name.not_nil!

yepics.each do |yepic|
  context = Context.new
  context.script_file = @@file_name

  begin
    yepic.each do |task,data|
      case task
      when "epic"
        info("Epic: #{data}", "\n")
      when "hosts"
        context.hosts = data
      when "story"
        Section.parse(context, data)
      when "bringup"
        Section.parse(context, data)
      when "teardown"
        Section.parse(context, data)
      end
    end
  ensure
    context.cleanup
  end

end
