module Fog
  # Wait for something to change to the specified status.
  #
  # @param [Hash] options
  #
  # @option options [Integer] :timeout  Maximum seconds to wait for the status change.
  # @option options [Proc]    :wait_policy  A proc that returns an integer. 
  #   The returned value will be used as the parameter of the 'sleep' call.
  # @option options [Array]   :ignored_errors Ignore errors within this array and resume the retry.
  # @option options [Integer] :max_retries  Maximum times to retry. 
  #   Stop retry  ether when times exceeded or timeout occurred.
  def self.wait_for(options={}, *bc_params, &block)
    duration = 0
    retries = 0

    options = Fog.wait_for_bc_options(options, *bc_params)
    max_retries = options[:max_retries] || 65535
    ignored_errors = options[:ignored_errors] || []
    wait_policy = options[:wait_policy] || Fog.interval
    timeout = options[:timeout] || Fog.timeout

    begin
      loop do
        raise Errors::TimeoutError, "The specified wait_for timeout (#{timeout} seconds) was exceeded" if duration >= timeout
        raise Errors::RetryTimesExceeded, "The specified :max_retries (#{max_retries}) was exceeded" if retries > max_retries
        return { :duration => duration } if yield
        duration += Fog.wait(retries += 1, wait_policy)
      end
    rescue *ignored_errors => e
      raise Errors::RetryTimesExceeded, "The specified :max_retries (#{max_retries}) was exceeded" if retries > max_retries
      duration += Fog.wait(retries += 1, wait_policy)
      retry
    end
  end

  def self.wait(retries, policy)
    interval = policy.respond_to?(:call) ? policy.call(retries) : policy
    sleep(interval.to_f)
  end

  def self.wait_for_bc_options(options = {}, *bc_params)
    # For BC purpose. 
    unless options.kind_of?(Hash)
      Fog::Logger.deprecation "Calling Fog.wait_for with interger params is deprecated. "\
        "Please call it this way: Fog.wait_for(:timeout => 3, :wait_policy => proc or interval, :max_retries => 2, :ignored_errors => [some errors])"
      options = {
        :timeout => options, 
        :wait_policy => bc_params.first
      }
    end
    options
  end
end
