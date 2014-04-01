require 'fog/core/collection'

module Fog
  module Orchestration

    class Outputs < Fog::Collection

      def all(stack)
        raise NotImplemented
      end

      def find_by_key(key)
        self.find {|output| output.key == key}
      end
      alias_method :find_by_id, :find_by_key
      alias_method :get, :find_by_key
    end

  end
end
