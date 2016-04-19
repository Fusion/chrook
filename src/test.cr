require "yaml"
require "./ansiblelikepg/*"
require "./ansiblelikepg/environment/*"
require "./ansiblelikepg/actions/*"

# DESIRED PLUGINS
# -ensure_file_exists
# -ensure_file_exists_and_is <file>
# -ensure_file_contains // will append
# -
#
def abort(cleartext, ex = nil)
  puts "Aborting: #{cleartext}"
  puts ex if ex != nil
  exit
end

def info(msg, prefix = "")
  puts "#{prefix}# #{msg}"
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

# TODO we will need to use fibers

yepics = YAML.parse File.read "test.yml"

#1 We need hosts
yepics.each do |yepic|
  context = Context.new

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

  #info = HostInfo.new("192.168.1.115", UserInfo.new("chrook", "chrook"))
  #runner.run_command(info, "ls")
end
