# frozen_string_literal: true

require 'socket'

# Simple reactor using IO.select
class Reactor
  def initialize
    @readable = {}
    @writable = {}
  end

  def run
    _error_events = [] # unused for now...
    while @readable.any? || @writable.any?
      readable, writable = IO.select(@readable.keys, @writable.keys, _error_events)

      readable.each do |io|
        @readable[io].resume
      end

      writable.each do |io|
        @writable[io].resume
      end
    end
  end

  def wait_readable(io)
    @readable[io] = Fiber.current
    Fiber.yield
    @readable.delete(io)

    yield if block_given?
  rescue Errno::ECONNRESET
    $stdout.puts "IO #{io} unreachale. Passing.."
  end

  def wait_writable(io)
    @writable[io] = Fiber.current
    Fiber.yield
    @writable.delete(io)

    yield if block_given?
  rescue Errno::ECONNRESET
    $stdout.puts "Writable IO #{io} unreachale. Passing.."
  end
end
