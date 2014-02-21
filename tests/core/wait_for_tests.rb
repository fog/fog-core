Shindo.tests('Fog#wait_for', 'core') do
  tests("success") do
    tests('Fog#wait_for').formats(:duration => Integer) do
      Fog.wait_for(1) { true }
    end

    tests('Fog#wait_for with callback').formats(:duration => Integer) do
      exponential_callback = lambda { |times| [2 ** (times - 1), 3].min }
      times = 0
      ret = Fog.wait_for(5, exponential_callback) { (times += 1) > 2 }
      returns(true) { ret[:duration] < 4 && ret[:duration] >= 3 }
    end
  end
  
  tests("failure") do
    tests('Fog#wait_for').raises(Fog::Errors::TimeoutError) do
      Fog.wait_for(2) { false }
    end
  end
end
