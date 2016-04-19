require "../../../libs/ssh2/src/ssh2.cr"

class SSH2Runner < Runner
  def run_exclusive(info, &block)
    SSH2::Session.open(info.host) do |session|
      session.login(info.username, info.password)
      session.open_session do |ch|
        yield ch
      end
    end
  end

  def run_command(hostinfo, cmd)
    run_exclusive(hostinfo) do |ch|
      ch.command(cmd)
      IO.copy(ch, STDOUT)
    end
  end

  def test
    SSH2::Session.open("192.168.1.115") do |session|
      session.login("chrook", "chrook")
      session.open_session do |ch|
        ch.command("ls")
        IO.copy(ch, STDOUT)
      end
    end
  end
end
