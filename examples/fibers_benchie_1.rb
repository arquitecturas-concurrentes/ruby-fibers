# frozen_string_literal: true

require 'benchmark'
require 'fiber'

fibers = []
times = 2e4.to_i

Benchmark.bm do |benchmark|
  benchmark.report("Creating #{times} fibers") do
    times.times do |i|
      fibers[i] = Fiber.new do
        loop do
          Fiber.yield i
        end
      end
    end
  end
  benchmark.report('Resuming fibers...') do
    fibers.each(&:resume)
  end
end
