require 'spec_helper'

describe Fog::Service do
  class TestService < Fog::Service
    requires :generic_api_key
    recognizes :generic_user

    class Real
      attr_reader :options

      def initialize(opts = {})
        @options = opts
      end
    end

    class Mock < Real
    end
  end

  it "properly passes headers" do
    user_agent_hash = {
      "User-Agent" => "Generic Fog Client"
    }
    params = {
      :generic_user => "bob",
      :generic_api_key => "1234",
      :connection_options => {
        :headers => user_agent_hash
      }
    }
    service = TestService.new(params)

    assert_equal user_agent_hash, service.options[:connection_options][:headers]
  end

  describe "when created with a Hash" do
    it "raises for required argument that are missing" do
      proc { TestService.new({}) }.must_raise ArgumentError
    end

    it "converts String keys to be Symbols" do
      service = TestService.new "generic_api_key" => "abc"
      service.options.keys.must_include :generic_api_key
    end

    it "removes keys with `nil` values" do
      service = TestService.new :generic_api_key => "abc", :generic_user => nil
      service.options.keys.wont_include :generic_user
    end

    it "converts number String values with to_i" do
      service = TestService.new :generic_api_key => "3421"
      service.options[:generic_api_key].must_equal 3421
    end

    it "converts 'true' String values to TrueClass" do
      service = TestService.new :generic_api_key => "true"
      service.options[:generic_api_key].must_equal true
    end

    it "converts 'false' String values to FalseClass" do
      service = TestService.new :generic_api_key => "false"
      service.options[:generic_api_key].must_equal false
    end

    it "warns for unrecognised options" do
      bad_options = { :generic_api_key => "abc", :bad_option => "bad value" }
      logger = Minitest::Mock.new
      logger.expect :warning, nil, ["Unrecognized arguments: bad_option"]
      Fog.stub_const :Logger, logger do
        TestService.new(bad_options)
      end
      logger.verify
    end
  end

  describe "when creating and mocking is disabled" do
    it "returns mocked service" do
      Fog.stub :mocking?, false do
        service = TestService.new(:generic_api_key => "abc")
        service.must_be_instance_of TestService::Real
      end
    end
  end

  describe "when creating and mocking is enabled" do
    it "returns mocked service" do
      Fog.stub :mocking?, true do
        service = TestService.new(:generic_api_key => "abc")
        service.must_be_instance_of TestService::Mock
      end
    end
  end
end
