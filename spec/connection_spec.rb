require 'spec_helper'

describe Fog::Core::Connection do 
  it "raises ArgumentError when no arguments given" do
    assert_raises(ArgumentError) do
      Fog::Core::Connection.new
    end
  end

  [:request, :reset].each do |method|
    it "responds to #{method}" do
      connection = Fog::Core::Connection.new("http://example.com")
      assert connection.respond_to?(method)
    end
  end

  it "writes the Fog::VERSION to the User-Agent header" do
    connection = Fog::Core::Connection.new("http://example.com")
    assert_equal "fog/#{Fog::VERSION}", 
      connection.instance_variable_get(:@excon).data[:headers]["User-Agent"]
  end

  it "doesn't error when persistence is enabled" do
    Fog::Core::Connection.new("http://example.com", true)
  end

  it "doesn't error when persistence is enabled and debug_response is disabled" do
    options = {
      :debug_response => false
    }
    Fog::Core::Connection.new("http://example.com", true, options)
  end

  describe "#new :base_path" do
    it "does not emit a warning when provided this argument" do
      $stderr = StringIO.new
      
      Fog::Core::Connection.new("http://example.com", false, :base_path => "foo")
      
      assert_empty($stderr.string)
    end
  end
end
