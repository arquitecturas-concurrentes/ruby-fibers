require 'fiber'
require 'io/nonblock'

class SimpleScheduler
  def initialize
    @readable = {}
    @writable = {}
    @waiting = {}
    @ready = []
    @blocking = 0
    @urgent = IO.pipe
  end

  def run
    while @readable.any? || @writable.any? || @waiting.any? || @blocking.positive? || @ready.any?
      readable, writable = IO.select(@readable.keys + [@urgent.first], @writable.keys, [], 0)

      readable&.each do |io|
        if (fiber = @readable.delete(io))
          fiber.resume
        end
      end

      writable&.each do |io|
        if (fiber = @writable.delete(io))
          fiber.resume
        end
      end

      @waiting.keys.each do |fiber|
        if current_time > @waiting[fiber]
          @waiting.delete(fiber)
          fiber.resume
        end
      end

      @ready = []
      ready = @ready
      ready.each(&:resume)
    end
  end

  def io_wait(io, events, timeout)
    @readable[io] = Fiber.current unless (events & IO::READABLE).zero?
    @writable[io] = Fiber.current unless (events & IO::WRITABLE).zero?

    Fiber.yield
    events
  end

  def kernel_sleep(duration = nil)
    block(:sleep, duration)
    true
  end

  def block(blocker, timeout = nil)
    if timeout
      @waiting[Fiber.current] = current_time + timeout
      begin
        Fiber.yield
      ensure
        @waiting.delete(Fiber.current)
      end
    else
      @blocking += 1
      begin
        Fiber.yield
      ensure
        @blocking -= 1
      end
    end
  end

  def unblock(blocker, fiber)
    @ready << fiber
    io = @urgent.last
    io.write_nonblock('.')
  end

  def close
    run
    @urgent.each(&:close)
    @urgent = nil
  end

  private

  def current_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
end
