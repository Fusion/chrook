require "../action.cr"

# TODO:10 Limitations:
# For now, only apt-get based OS supported
class Packages  < Action

  def run(context : Context, run_as, *args)
    log 3, run_as, "Hello"
    context.runners.traverse do |runner|
      mgr = detect_distro runner
      return if mgr.installed? args[0]
      log 3, run_as, runner.hostname, "Package '#{args[0]}' not installed -- installing."
      mgr.install args[0]
    end
  end

  private def detect_distro(runner)
    # which yum, apt-get, apk
      rows = (runner.execute ["which apt-get dnf yum apk"]).split("\n")
      case mgr = rows[0].split('/')[-1]
      when "apt-get"
        AptManager.new runner
      when "dnf"
        DnfManager.new runner
      when "yum"
        YumManager.new runner
      when "apk"
        ApkManager.new runner
      else
        abort "Unknown package manager: #{mgr}"
      end
  end

  abstract class AbsManager
    def initialize(@runner)
    end

    abstract def installed?(pkg)
    abstract def install(pkg)
  end

  class AptManager < AbsManager
    def installed?(pkg)
      "0" == @runner.execute(["dpkg-query -W #{pkg}; echo $?"]).strip
    end

    # TODO:20 Need to implement support for sudo and su (at least!) issue:1
    def install(pkg)
      abort "Failed to install package '#{pkg}'" if "0" != @runner.execute(["apt-get install -y #{pkg}; echo $?"])
    end
  end

  class DnfManager < AbsManager
    def installed?(pkg)
      true
    end

    def install(pkg)
    end
  end

  class YumManager < AbsManager
    def installed?(pkg)
      true
    end

    def install(pkg)
    end
  end

  class ApkManager < AbsManager
    def installed?(pkg)
      true
    end

    def install(pkg)
    end
  end
end

register_action "package", Packages
