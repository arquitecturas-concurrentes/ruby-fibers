# frozen_string_literal: true

# Transfer
require 'fiber' # otherwise we'll get  undefined method `transfer' for #<Fiber:0x000055eb3f57da98 fibers_2.5.rb:1 (created)> (NoMethodError)

fiber1 = Fiber.new do
  puts 'In Fiber 1'
  Fiber.yield
  puts 'In Fiber 1 again'
end
fiber2 = Fiber.new do
  puts 'In Fiber 2'
  fiber1.transfer
  puts 'Never see this message'
end
fiber3 = Fiber.new do
  puts 'In Fiber 3'
end

fiber2.resume
fiber3.resume
fiber1.resume rescue (p $!)
fiber1.transfer
