module Fog
  def self.wait_for(timeout=Fog.timeout, sleeper=Fog.interval, &block)
    duration = 0
    start = Time.now
    times = 0
    until yield || duration > timeout
      interval = sleeper.respond_to?(:call) ? sleeper.call(times += 1) : sleeper
      sleep(interval.to_f)
      duration = Time.now - start
    end
    if duration > timeout
      raise Errors::TimeoutError.new("The specified wait_for timeout (#{timeout} seconds) was exceeded")
    else
      { :duration => duration }
    end
  end
end
