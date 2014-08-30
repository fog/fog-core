require 'fog/core/collection'

module Fog
  module Orchestration
    # Stack events
    class Events < Fog::Collection

      # @return [Fog::Orchestration::Stack]
      attr_accessor :stack

      # Load all events for stack
      #
      # @param stack [Fog::Orchestration::Stack]
      # @return [self]
      # @note events should be ordered by timestamp
      #   in ascending order
      def all(stack=nil)
        raise NotImplementedError
      end

      # Fetch event by ID
      #
      # @param id [String]
      # @return [Fog::Orchestration::Event]
      def get(id)
        self.find {|event| event.id == id}
      end

    end

  end
end
