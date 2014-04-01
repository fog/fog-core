require 'fog/core/model'

module Fog
  module Orchestration

    class Output < Fog::Model

      def self.inherited(klass)
        klass.class_eval do
          identity :key

          attribute :key
          attribute :value
          attribute :description
        end
      end

    end

  end
end
