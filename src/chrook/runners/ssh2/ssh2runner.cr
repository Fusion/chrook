require "../../../../libs/ssh2/src/ssh2.cr"

class SSH2Runner < Runner
  def open
    session = @session = (SSH2::Session.open_session @hostinfo.address) as SSH2::Session
    session.login @hostinfo.username, @hostinfo.password
  end

  def close
    SSH2::Session.close_session @session
  end

  # TODO:0 Currently, runner this will only return the output of the last command issue:2
  def execute(cmds)
    session = @session.not_nil!

    output_bufs = [] of String

    cmds.each do |cmd|
      max_alloc = 32768
      tail_idx = 0
      cmd_buf = Pointer(UInt8).malloc(max_alloc)
      session.open_session do |channel|
        full_cmd = "#{cmd as String}; echo -n '<chrooked>'"
        channel.command full_cmd

        loop do
          inp = Slice(UInt8).new(32768)
          len = channel.read(inp).to_i32
          if len > 0
            if len + tail_idx > max_alloc
              max_alloc *= 2
              cmd_buf = cmd_buf.realloc max_alloc
            end

            (cmd_buf + tail_idx).copy_from(inp.to_unsafe, len)
            tail_idx += len

            if tail_idx >= 10
              s = String.new cmd_buf+(tail_idx-10), 10
              if s == "<chrooked>"
                tail_idx -= 10
                break
              end
            end
          end
          break if channel.eof?
        end
        # This is not the answer:
        # Alternatively to debug quickly use:
        #IO.copy(ch, STDOUT)
      end
      output_bufs.push String.new Slice.new cmd_buf, tail_idx
    end

    output_bufs
  end
end
