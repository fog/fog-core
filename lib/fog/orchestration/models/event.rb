require 'fog/core/model'

module Fog
  module Orchestration
    # Stack event
    class Event < Fog::Model

      # Load common attributes into subclass
      #
      # @param klass [Class]
      def self.inherited(klass)
        klass.class_eval do
          identity :id

          attribute :id
          attribute :event_time
          attribute :links
          attribute :logical_resource_id
          attribute :physical_resource_id
          attribute :resource_name
          attribute :resource_status
          attribute :resource_status_reason
        end
      end

    end

  end
end
