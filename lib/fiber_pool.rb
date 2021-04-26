# frozen_string_literal: true

require 'fiber'
require_relative 'reporter'

# FiberPool
class FiberPool
  attr_reader :fibers, :pool_size, :pool_fiber, :reporter

  def initialize(pool_size = 10)
    @reporter = Reporter
    @pool_size = pool_size
    @fibers = []
    @pool_fiber = Fiber.current
    reporter.report_system "Initialized Fiber pool, with pool size #{pool_size}"
  end

  def self.start(pool_size = 10, finished_callback = nil, &_block)
    Fiber.new do
      pool = FiberPool.new(pool_size)
      yield pool
      pool.drain
      finished_callback&.call
    end.resume
  end

  def add(&_block)
    fiber = Fiber.new do
      f = Fiber.current
      completion_callback = proc do
        pool_fiber.transfer(f)
      end
      yield completion_callback
    end
    add_to_pool(fiber)
  end

  def add_to_pool(fiber)
    if over_capacity?
      wait_for_free_pool_space
      reporter.report_warning 'Pool with overcharged... waiting pool to free more space'
    end
    fibers << fiber
    remove_fiber_from_pool fiber.resume
  end

  def wait_for_free_pool_space

    remove_fiber_from_pool(wait_for_next_complete_fiber)
  end

  def wait_for_next_complete_fiber
    Fiber.yield
  end

  def over_capacity?
    fibers_in_use >= pool_size
  end

  def fibers_in_use
    fibers.size
  end

  def fibers_left_to_process?
    fibers_in_use.positive?
  end

  def remove_fiber_from_pool(fiber)
    reporter.report_info "Removing #{fiber} from pool."
    fibers.delete(fiber)
  end

  def drain
    wait_for_free_pool_space while fibers_left_to_process?
  end

  def to_s
    reporter.report_info "Pool id #{object_id}. Total Fibers #{fibers.count}. #{fibers.map(&:to_s).join('\n')}"
  end
end
