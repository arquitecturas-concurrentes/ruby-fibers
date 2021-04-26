require "socket"

port = 9090
s = TCPSocket.open("localhost", port)
s.puts "Hi"
while line = s.gets do puts "received : #{line.chop}... echoing #{s.puts("Hi")}" end
s.close