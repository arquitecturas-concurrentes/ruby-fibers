# frozen_string_literal: true

require 'socket'

port = 9090
server = TCPServer.new('localhost', port)
puts "Listening on 127.0.0.1:#{port}"

loop do
  client = server.accept

  fork do
    while buffer = client.gets
      puts "Got #{buffer}"
      client.puts("Received #{buffer}. Pong!")
    end

    client.close
  end

  client.close
end
