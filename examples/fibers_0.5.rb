require 'fiber'

# Dead fiber???

f = Fiber.new do
  puts "i'm alive!"
end

puts "have *not* resumed #{f}"
puts "Is it alive? => #{f.alive?}"

puts "Resuming #{f}..."
f.resume
puts "How alive is it now? => #{f.alive?}"
