
require_relative 'simple_scheduler'

scheduler = SimpleScheduler.new
Fiber.set_scheduler(scheduler)

# now using a non-blocking schema through a SimpleScheduler that does not block the Fibers
Fiber.new do
  puts 'Fiber 1: sleep for 2s'
  sleep(2)
  puts 'Fiber 1: wake up'
end.resume

Fiber.new do
  puts 'Fiber 2: sleep for 3s'
  sleep(3)
  puts 'Fiber 2: wake up'
end.resume

