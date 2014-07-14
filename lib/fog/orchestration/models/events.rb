require 'fog/core/collection'

module Fog
  module Orchestration

    class Events < Fog::Collection

      def all(stack)
        raise NotImplementedError
      end

      def get(id)
        self.find {|event| event.id == id}
      end

    end

  end
end
