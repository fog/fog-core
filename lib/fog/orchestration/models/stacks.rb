require 'fog/core/collection'

module Fog
  module Orchestration
    # All stacks
    class Stacks < Fog::Collection

      # @return [self]
      def all
        raise NotImplemented
      end

      # Fetch stack by name or ID
      #
      # @param name_or_id [String]
      # @return [Fog::Orchestration::Stack]
      def get(name_or_id)
        self.find do |stack|
          stack.id == name_or_id ||
            stack.stack_name == name_or_id
        end
      end

    end

  end
end
