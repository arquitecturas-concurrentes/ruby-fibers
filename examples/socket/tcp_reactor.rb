# frozen_string_literal: true

require 'fiber'
require_relative 'reactor'

port = 9090
server = TCPServer.new('localhost', port)
puts "Listening on 127.0.0.1:#{port}"
reactor = Reactor.new

Fiber.new do
  loop do
    client = reactor.wait_readable(server) { server.accept }

    Fiber.new do
      while (buffer = reactor.wait_readable(client) { client.gets })
        puts "Processing buffer #{buffer} for client #{client}"
        reactor.wait_writable(client)
        client.puts("Received #{buffer}. Pong!")
      end

      client.close
    end.resume
  end
end.resume

reactor.run
