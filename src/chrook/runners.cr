require "./runners/**"

class Runners

  def initialize
    @runners = {} of String => Runner
  end

  def context=(context)
    @context = context
  end

  # 1 runner per host, lazily initialized
  def get(host, driver)
    #SSH2Runner.new
  end

  def traverse(&block)
    @context.not_nil!.hosts.each do |host|
      hostinfo = HostInfo.new (host as CrHash)
      case driver_name = hostinfo.driver
      when "ssh2"
        if !@runners.has_key?(hostinfo.hostname)
          @runners[hostinfo.hostname] = SSH2Runner.new hostinfo
          @runners[hostinfo.hostname].open
        end
        # run cmd here!
      else
        abort "Unsupported driver: #{driver_name}"
      end
      #runner = @runners[host]
      # 1-check whether runner already instantiated for this hosts
      # 2-if not, instantiate
      # 3-yield with proper session opened
      # so for instance:
      # instantiate ssh runner, have it open ssh connection, yield with channel
      # well obviously channel will have to be decorated.
      yield @runners[hostinfo.hostname]
    end
  end

  def cleanup
    @runners.each do |hostname, runner|
      info "Closing runner for #{hostname}"
      runner.close
    end
  end
end
