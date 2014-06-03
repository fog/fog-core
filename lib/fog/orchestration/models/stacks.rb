require 'fog/core/collection'

module Fog
  module Orchestration

    class Stacks < Fog::Collection

      def all
        raise NotImplemented
      end

      def get(id)
        self.find {|stack| stack.id == id}
      end

    end

  end
end
