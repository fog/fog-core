require 'fog/core/collection'

module Fog
  module Orchestration
    # Stack resources
    class Resources < Fog::Collection

      # @return [Fog::Orchestration::Stack]
      attr_accessor :stack

      # Load all resources for stack
      #
      # @param stack [Fog::Orchestration::Stack]
      # @return [self]
      def all(stack=nil)
        raise NotImplemented
      end

      # Fetch resource by physical ID
      #
      # @param id [String]
      # @return [Fog::Orchestration::Resource]
      def find_by_physical_id(id)
        self.find {|resource| resource.physical_resource_id == id}
      end
      alias_method :get, :find_by_physical_id

      # Fetch resource by logical ID
      #
      # @param id [String]
      # @return [Fog::Orchestration::Resource]
      def find_by_logical_id(id)
        self.find {|resource| resource.logical_resource_id == id}
      end
    end

  end
end
