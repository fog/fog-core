Shindo.tests('Fog#wait_for', 'core') do
  tests("success") do
    tests('Fog#wait_for').formats(:duration => Integer) do
      Fog.wait_for(1) { true }
    end

    tests('Fog#wait_for with callback').formats(:duration => Integer) do
      callback = lambda { |times| times * 0.01 }
      Fog.wait_for(5, callback) { true }
    end
  end
  
  tests("failure") do
    tests('Fog#wait_for').raises(Fog::Errors::TimeoutError) do
      Fog.wait_for(2) { false }
    end
  end
end
