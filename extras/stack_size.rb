# frozen_string_literal: true

require 'dotenv'

Dotenv.load('../.env.local')

def recurse(number)
  return 1 if number == 1

  1 + recurse(number - 1)
end

def binary_search
  answer = 0
  a = 0
  b = 1_000_000_000

  while a <= b
    mid = (a + b) / 2
    begin
      recurse(mid)
      answer = mid
      a = mid + 1
    rescue SystemStackError
      b = mid - 1
    end
  end

  answer
end

puts "Max Stack Level: #{binary_search}"
