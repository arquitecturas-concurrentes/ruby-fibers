require 'fiber'

f = Fiber.new {
  puts "i'm alive!"
}

puts "have *not* resumed #{f}"
puts "Is it alive? => #{f.alive?}"

puts "Resuming #{f}..."
f.resume
puts "How alive is it now? => #{f.alive?}"