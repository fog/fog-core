require 'fog/core/collection'

module Fog
  module Orchestration

    class Stacks < Fog::Collection

      def all
        raise NotImplemented
      end

      def get(name_or_id)
        self.find do |stack|
          stack.id == name_or_id ||
            stack.stack_name == name_or_id
        end
      end

    end

  end
end
