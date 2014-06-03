require 'fog/core/collection'

module Fog
  module Orchestration

    class Outputs < Fog::Collection

      def all(stack)
        raise NotImplemented
      end

      def get(key)
        self.find {|output| output.key == key}
      end

    end

  end
end
