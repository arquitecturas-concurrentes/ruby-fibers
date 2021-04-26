# frozen_string_literal: true

require 'eventmachine'
require 'em-http'
require 'fiber'

# Using Fibers in Ruby 1.9 to simulate blocking IO / IO scheduling
# while using the async EventMachine API's

def async_fetch(url)
  f = Fiber.current
  http = EventMachine::HttpRequest.new(url, connect_timeout: 10, inactivity_timeout: 20).get

  http.callback { f.resume(http) }
  http.errback { f.resume(http) }

  Fiber.yield

  p [:HTTP_ERROR, http.error] if http.error

  http
end

EventMachine.run do
  Fiber.new do
    puts 'Setting up HTTP request #1'
    data = async_fetch('http://0.0.0.0/')
    puts "Fetched page #1: #{data.response_header.status}"

    puts 'Setting up HTTP request #2'
    data = async_fetch('http://www.google.com/')
    puts "Fetched page #2: #{data.response_header.status}"

    puts 'Setting up HTTP request #3'
    data = async_fetch('http://non-existing.domain/')
    puts "Fetched page #3: #{data.response_header.status}"

    EventMachine.stop
  end.resume
end

puts 'Done'
