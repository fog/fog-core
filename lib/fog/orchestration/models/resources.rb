require 'fog/core/collection'

module Fog
  module Orchestration

    class Resources < Fog::Collection

      def all(stack)
        raise NotImplemented
      end

      def find_by_physical_id(id)
        self.find {|resource| resource.physical_resource_id == id}
      end
      alias_method :get, :find_by_physical_id

      def find_by_logical_id(id)
        self.find {|resource| resource.logical_resource_id == id}
      end
    end

  end
end
