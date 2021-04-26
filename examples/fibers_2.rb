# frozen_string_literal: true

require 'fiber'

fiber = Fiber.new do |a|
  b = a * Fiber.yield('hello')
  b
end

value = fiber.resume(6) # inside fiber: a = 6; value1 = hello
puts value

calculated_value = fiber.resume(7) # inside fiber: Fiber.yield return 7; val2 = 42
puts calculated_value
