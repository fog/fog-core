require 'fog/core/model'

module Fog
  module Orchestration

    class Resource < Fog::Model

      def self.inherited(klass)
        klass.class_eval do
          identity :physical_resource_id

          attribute :resource_name
          attribute :links
          attribute :logical_resource_id
          attribute :physical_resource_id
          attribute :resource_type
          attribute :resource_status
          attribute :resource_status_reason
          attribute :updated_time
        end
      end

    end

  end
end
