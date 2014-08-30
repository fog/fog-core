require 'fog/core/collection'

module Fog
  module Orchestration
    # Stack outputs
    class Outputs < Fog::Collection

      # @return [Fog::Orchestration::Stack]
      attr_accessor :stack

      # Load all outputs for stack
      #
      # @param stack [Fog::Orchestration::Stack]
      # @return [self]
      def all(stack=nil)
        raise NotImplemented
      end

      # Fetch output by key
      #
      # @param key [String]
      # @return [Fog::Orchestration::Output]
      def get(key)
        self.find {|output| output.key == key}
      end

    end

  end
end
