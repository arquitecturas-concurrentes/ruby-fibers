# frozen_string_literal: true

# fibers_1.rb

a = Fiber.new do
  puts 'hola 1'
  Fiber.yield
  puts 'hola 2'
end

b = Fiber.new do
  puts 'ejecuto b 1'
  Fiber.yield
  puts 'ejecuto b 2'
  return 1
end

# a.resume
# b.resume
# > hola 1
# > ejecuto b 1

# a.resume
# b.resume
# a.resume
# b.resume
# a.resume
# > hola 1
# > ejecuto b 1
# > hola 2
# > ejecuto b 2
# > fibers_1.rb:24:in `resume': dead fiber called (FiberError)
#         from fibers_1.rb:24:in `<main>'
