require_relative '../spec_helper'

require "fog/core"

describe Fog::Core::Connection do
	describe "When no arguments given" do
		it "raises an argument error" do
   			proc { Fog::Core::Connection.new }.must_raise ArgumentError
  		end
	end
	describe "When creating with a url " do
		before do
			@connection = Fog::Core::Connection.new("http://example.com")
	    end
		it "#request" do
			@connection.must_respond_to(:request)
		end
		it "#reset" do
			@connection.must_respond_to(:reset)
		end

		it "should have an appropriate user-agent" do
			@connection.http_client.data[:headers]['User-Agent'].must_equal("fog/#{Fog::VERSION}")
		end
	end
	describe "When creating with a url and a persistence value " do
		it "and persistence is true" do
			lambda { Fog::Core::Connection.new("http://example.com", true) }
	    end

	    it "and persistence is false" do
			lambda { Fog::Core::Connection.new("http://example.com", false) }.must_be_silent
	    end

	    describe "and options are passed" do
	    	it "consumes the options" do
	    		options = {
      				:debug_response => false
    			}
    			lambda { Fog::Core::Connection.new("http://example.com", false,options) }.must_be_silent
        end
        describe "and an httpclient is specified" do
          before do
            options = {
              :http_client => Faraday
            }
            @instance = Fog::Core::Connection.new("http://example.com", true, options)
          end

          it "responds to the same methods as the default provider" do
            @instance.must_respond_to(:request)
            @instance.must_respond_to(:reset)
            @instance.http_client.headers['User-Agent'].must_equal("fog/#{Fog::VERSION}")
          end

          it "fetches results" do
           lambda { @instance.request("http://www.example.com") }.must_be_silent
          end


        end
	    end
	end
end
