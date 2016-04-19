require "./runners/*"
class Runners
  def context=(context)
    @context = context
  end

  # 1 runner per host, lazily initialized
  def get(host, driver)
    #SSH2Runner.new
  end

  def run(&block)
    @context.not_nil!.hosts.each do |host|
      # 1-check whether runner already instantiated for this hosts
      # 2-if not, instantiate
      # 3-yield with proper session opened
      # so for instance:
      # instantiate ssh runner, have it open ssh connection, yield with channel
      # well obviously channel will have to be decorated.
      yield host # nope!
    end
  end
end
