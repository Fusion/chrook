require "socket"

class SSH2::Session
  def self.open_session(host, port = 22)
    tmp_session = new
    tmp_session.handshake TCPSocket.new host, port
    tmp_session
  end

  def self.close_session(tmp_session)
    tmp_session.not_nil!.disconnect
    tmp_session.not_nil!.socket.not_nil!.close
  end
end
