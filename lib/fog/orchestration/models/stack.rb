require 'fog/core/model'

module Fog
  module Orchestration

    class Stack < Fog::Model

      class << self

        def resources(model_klass=nil)
          if(model_klass)
            @resources_model = model_klass
          end
          @resources_model
        end

        def events(model_klass=nil)
          if(model_klass)
            @events_model = model_klass
          end
          @events_model
        end

        def outputs(model_klass=nil)
          if(model_klass)
            @outputs_model = model_klass
          end
          @outputs_model
        end

        def inherited(klass)
          klass.class_eval do
            identity :id

            attribute :stack_name
            attribute :stack_status
            attribute :stack_status_reason
            attribute :creation_time
            attribute :updated_time
            attribute :id

            attribute :template_url
            attribute :template
            attribute :parameters
            attribute :timeout_in_minutes
            attribute :disable_rollback
            attribute :capabilities
            attribute :notification_topics
            attribute :template_description
          end
        end

      end

      def save
        requires :stack_name
        identity ? update : create
      end

      def create
        raise NotImlemented
      end

      def update
        raise NotImlemented
      end

      def destroy
        raise NotImlemented
      end

      def resources
        if(self.class.resources)
          self.class.resources.new(:service => service).all(self)
        else
          raise NotImplemented
        end
      end

      def events
        if(self.class.events)
          self.class.events.new(:service => service).all(self)
        else
          raise NotImplemented
        end
      end

      def outputs
        if(self.class.outputs)
          self.class.outputs.new(:service => service).all(self)
        else
          raise NotImplemented
        end
      end

      def validate
        requires :template
        raise NotImplemented
      end

    end
  end
end
