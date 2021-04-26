# frozen_string_literal: true

require 'fiber'
require 'benchmark'

def sec_fibonacci(number)
  return number if [0, 1].include?(number)

  sec_fibonacci(number - 1) + sec_fibonacci(number - 2)
end

# Tail Recursive Fibonacci
class TailrecursiveFibonacci
  def self.calculate(number)
    fibo_tail_recursive(number, 0, 1)
  end

  def self.fibo_tail_recursive(number, acc1, acc2)
    if number.zero?
      0
    elsif number < 2
      acc2
    else
      fibo_tail_recursive(number - 1, acc2, acc2 + acc1)
    end
  end
end

def get_fibrous_fibonacci
  Fiber.new do
    a = 1
    b = 1
    loop do
      Fiber.yield(a)
      a, b = b, a + b
    end
  end
end

def puts_fibonacci(number)
  fiber = get_fibrous_fibonacci
  number.times { puts fiber.resume }
end

puts_fibonacci(45)

## Benching...
MAGIC_NUMBER = 40

Benchmark.bm do |benchmark|
  benchmark.report('Secuential Fibonacci') do
    sec_fibonacci(MAGIC_NUMBER)
  end
  benchmark.report('TR Fibonacci') do
    TailrecursiveFibonacci.calculate(MAGIC_NUMBER)
  end
  benchmark.report('Fibrous Fibonacci') do
    fiber = get_fibrous_fibonacci
    MAGIC_NUMBER.times { fiber.resume }
  end
end

