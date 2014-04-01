require 'fog/core/collection'

module Fog
  module Orchestration

    class Stacks < Fog::Collection

      def all
        raise NotImplemented
      end

      def find_by_id(id)
        self.find {|stack| stack.id == id}
      end
      alias_method :get, :find_by_id
    end

  end
end
