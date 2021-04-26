# frozen_string_literal: true

# fibers_0.rb => secuencial... sin fibers

def a
  puts 'hola 1'
  puts 'hola 2'
end

def b
  puts 'ejecuto b 1'
  puts 'ejecuto b 2'
end

a
b
