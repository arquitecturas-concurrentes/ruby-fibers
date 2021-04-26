# frozen_string_literal: true

# Blocking fibers...
require 'fiber'
require_relative './simple_scheduler'

blocking_fiber = Fiber.new do
  puts 'blocking for 10 seconds...'
  sleep 10
  puts 'hola 1'
  Fiber.yield
  puts 'hola 2'
end

blocking_fiber.resume
blocking_fiber.resume
