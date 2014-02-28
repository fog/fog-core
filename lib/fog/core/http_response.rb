module Fog
  module Core

    # Fog::Core::HttpResponse is a generic wrapper class to contain a HTTP responses from the  API.
    #
    #
    class HttpResponse
    	attr_reader raw_response
    	def initialize(resp = nil)
    		raw_response = resp if resp
    		end

    end
 end
end