require 'fog/core/errors'

module Fog
  module Errors

    # Orchestration related errors
    class OrchestrationError < Error

      # Invalid template error
      class InvalidTemplate < OrchestrationError
      end

    end

  end
end
