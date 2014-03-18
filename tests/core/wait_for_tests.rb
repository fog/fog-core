Shindo.tests('Fog#wait_for', 'core') do
  tests("success") do
    tests('Fog#wait_for BC').formats(:duration => Integer) do
      Fog.wait_for(1) { true }
    end

    tests("Fog#wait_for with :wait_policy").formats(:duration => Integer) do
      wait_policy = lambda { |times| times * 0.01 }
      Fog.wait_for(:wait_policy => wait_policy) { true }
    end
  end
  
  tests("failure") do
    tests('Fog#wait_for').raises(Fog::Errors::TimeoutError) do
      Fog.wait_for(2) { false }
    end

    tests("Fog#wait_for with :timeout").raises(Fog::Errors::TimeoutError) do
      i = 0
      Fog.wait_for(:timeout => 1) { i += 1; i > 2 }
    end

    tests("Fog#wait_for with :max_retries").raises(Fog::Errors::RetryTimesExceeded) do
      i = 0
      Fog.wait_for(:max_retries => 1) { i += 1; i > 2 }
    end
  end
end
