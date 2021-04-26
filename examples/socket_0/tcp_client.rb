# frozen_string_literal: true

require 'socket'

threads = []
port = 9090

5.times do |th_number|
  puts "Starting thread number #{th_number}"
  threads << Thread.new(th_number) do |th_number|
    s = TCPSocket.open('localhost', port)
    s.puts 'Starting sending info...'
    loop do
      line = s.gets
      $stdout.puts "received : #{line.chop}... echoing.."
      s.puts("Generating a new message with data #{rand}. Thread #{th_number}")
    end
    s.close
  end
end

threads.each(&:join)
