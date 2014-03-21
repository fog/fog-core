require 'spec_helper'

describe "Fog::Service" do
  class TestService < Fog::Service
    recognizes :generic_user, :generic_api_key

    class Real
      attr_reader :options

      def initialize(opts={})
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
    params = { :generic_user => "bob", :generic_api_key => "1234", :connection_options => {:headers => user_agent_hash }}
    service = TestService.new(params)

    assert_equal user_agent_hash, service.options[:connection_options][:headers]
  end
end
