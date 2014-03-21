require_relative 'spec_helper'

describe "Fog#timeout" do
  it "defaults to 600" do
    assert_equal 600, Fog.timeout
  end

  it "can be reassigned through Fog#timeout=" do
    Fog.timeout = 300
    assert_equal 300, Fog.timeout
  end
end

