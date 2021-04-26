# frozen_string_literal: true

require 'fiber'

def benchie(&_block)
  t0 = Time.now
  yield
  Time.now - t0
end

times = 1_000_000

fiber = Fiber.new do
  loop { Fiber.yield }
end

dt = benchie { times.times { fiber.resume } }

puts "#{times / dt.to_f}/s"


# Using /home/ernesto/.rvm/gems/ruby-2.5.1
# altair.λ:~/utn/iasc/fibers-ruby/lib$ ruby fibers_benchie.rb
# 1220634.1484423832/s
# Using /home/ernesto/.rvm/gems/ruby-3.0.0-preview1
# altair.λ:~/utn/iasc/fibers-ruby/lib$ ruby fibers_benchie.rb
# 4197152.191945104/s
