# frozen_string_literal: true

require 'eventmachine'
require 'fiber'

def rpc(val)
  f = Fiber.current # get the current fiber

  d = EventMachine::DefaultDeferrable.new
  d.callback do
    f.resume(val)
  end

  EventMachine.add_timer(0.1) do
    d.succeed
  end

  Fiber.yield
end


EventMachine.run do
  start_time = Time.now

  Fiber.new do
    start = Time.now
    result = rpc(1) + rpc(2)
    puts "Ran for: #{Time.now - start}"
    puts result
  end.resume

  # just quit after half a sec
  EventMachine.add_timer(0.5) do
    puts "Total Runtime: #{Time.now - start_time}"
    EventMachine.stop
  end
end
