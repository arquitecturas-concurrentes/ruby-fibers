# frozen_string_literal: true

require_relative './fiber_pool'
require 'em-http-request'
require 'json'

max_concurrency = 10
pool_complete_callback = proc { puts 'Finished...' }

ERROR_THRESHOLD = 0.05

def roll
  if rand < ERROR_THRESHOLD
    pp 'Failing..'
    return
  end

  rand(1..150)
end

def process_success(request)
  poke_name = JSON.parse(request.response, symbolize_names: true)[:name]
  pp "Found #{poke_name}"
rescue JSON::ParserError
 pp 'Failed parsing response'
end

def process_failure(request)
  pp "Failed getting this request #{request.req.uri}"
end

request_options = {
  head: {
    'content-type' => 'application/json',
    'accept' => 'application/json',
    'Accept-Encoding' => 'gzip,deflate,sdch'
  }
}

def url
  poke_id = roll
  return 'http://non-existing.domain/' if poke_id.nil?

  "https://pokeapi.co/api/v2/pokemon/#{poke_id}"
end

EM.run do
  FiberPool.start(max_concurrency, pool_complete_callback) do |pool|
    35.times do
      pool.add do |job_completed|
        u = url
        puts u
        request = EventMachine::HttpRequest.new(u,
                                                ssl: {verify_peer: true},
                                                connect_timeout: 10,
                                                inactivity_timeout: 20).get request_options
        request.callback do
          process_success(request)
          job_completed.call
        end
        request.errback do
          process_failure(request)
          job_completed.call
        end
      end
    end
  end
end
