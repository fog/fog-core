require 'fog/core/model'

module Fog
  module Orchestration
    # Stack output
    class Output < Fog::Model

      # Load common attributes into subclass
      #
      # @param klass [Class]
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
