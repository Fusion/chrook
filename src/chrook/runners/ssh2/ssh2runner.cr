require "../../../../libs/ssh2/src/ssh2.cr"

class SSH2Runner < Runner
  def open
    session = @session = (SSH2::Session.open_session @hostinfo.address) as SSH2::Session
    session.login @hostinfo.username, @hostinfo.password
  end

  def close
    SSH2::Session.close_session @session
  end

  # TODO Currently this will only return the output of the last command
  def execute(cmds)
    session = @session.not_nil!
    buf = Slice(UInt8).new(32768)
    len = 0

    cmds.each do |cmd|
      session.open_session do |channel|
        channel.command(cmd as String)
        len = channel.read(buf).to_i32
        # This is not the answer:
        # Alternatively to debug quickly use:
        # IO.copy(ch, STDOUT)
      end
    end
    String.new buf[0, len]
  end
end
