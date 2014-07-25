require 'fog/core/model'

module Fog
  module Orchestration
    # Stack model
    class Stack < Fog::Model

      class << self

        # Register resources collection class
        #
        # @param model_klass [Class]
        # @return [Class]
        def resources(model_klass=nil)
          if(model_klass)
            @resources_model = model_klass
          end
          @resources_model
        end

        # Register events collection class
        #
        # @param model_klass [Class]
        # @return [Class]
        def events(model_klass=nil)
          if(model_klass)
            @events_model = model_klass
          end
          @events_model
        end

        # Register outputs collection class
        #
        # @param model_klass [Class]
        # @return [Class]
        def outputs(model_klass=nil)
          if(model_klass)
            @outputs_model = model_klass
          end
          @outputs_model
        end

        # Load common attributes into subclass
        #
        # @param klass [Class]
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

      # Save the stack
      #
      # @return [self]
      def save
        requires :stack_name
        identity ? update : create
      end

      # Create the stack
      #
      # @return [self]
      def create
        raise NotImlemented
      end

      # Update the stack
      #
      # @return [self]
      def update
        raise NotImlemented
      end

      # Destroy the stack
      #
      # @return [self]
      def destroy
        raise NotImlemented
      end

      # @return [Fog::Orchestration::Resources]
      def resources
        if(self.class.resources)
          self.class.resources.new(:service => service).all(self)
        else
          raise NotImplemented
        end
      end

      # @return [Fog::Orchestration::Events]
      def events
        if(self.class.events)
          self.class.events.new(:service => service).all(self)
        else
          raise NotImplemented
        end
      end

      # @return [Fog::Orchestration::Outputs]
      def outputs
        if(self.class.outputs)
          self.class.outputs.new(:service => service).all(self)
        else
          raise NotImplemented
        end
      end

      # Validate the stack template
      #
      # @return [TrueClass]
      # @raises [Fog::Errors::OrchestationError::InvalidTemplate]
      def validate
        raise NotImplemented
      end

    end
  end
end
