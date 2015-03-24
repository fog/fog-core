module Fog
  def self.wait_for(timeout = Fog.timeout, interval = Fog.interval, &_block)
    duration = 0
    start = Time.now
    retries = 0
    loop do
      break if yield
      raise Errors::TimeoutError, "The specified wait_for timeout (#{timeout} seconds) was exceeded" if duration > timeout
      sleep(interval.respond_to?(:call) ? interval.call(retries += 1).to_f : interval.to_f)
      duration = Time.now - start
    end
    { :duration => duration }
  end
end
