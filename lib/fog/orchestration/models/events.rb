require 'fog/core/collection'

module Fog
  module Orchestration

    class Events < Fog::Collection

      def all(stack)
        raise NotImplemented
      end

      def find_by_id(id)
        self.find {|event| event.id == id}
      end
      alias_method :get, :find_by_id
    end

  end
end
