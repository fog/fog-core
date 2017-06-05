module Fog
  class Service
    module Collections
      def mocked_requests
        service.mocked_requests
      end
    end

    class << self
      # {Fog::Service} is (unfortunately) both a builder class and the subclass for any fog service.
      #
      # Creating a {new} instance using the builder will return either an instance of
      # +Fog::<Service>::<Provider>::Real+ or +Fog::<Service>::<Provider>::Mock+ based on the value
      # of {Fog.mock?} when the builder is used.
      #
      # Each provider can require or recognize different settings (often prefixed with the providers
      # name). These settings map to keys in the +~/.fog+ file.
      #
      # Settings can be passed as either a Hash or an object that responds to +config_service?+ with
      # +true+. This object will be passed through unchanged to the +Real+ or +Mock+ service that is
      # created. It is up to providers to adapt services to use these config objects.
      #
      # @abstract Subclass and implement real or mock code
      #
      # @param [Hash,#config_service?] config
      #   Settings or an object used to build a service instance
      # @option config [Hash] :headers
      #   Passed to the underlying {Fog::Core::Connection} unchanged
      #
      # @return [Fog::Service::Provider::Real] if created while mocking is disabled
      # @return [Fog::Service::Provider::Mock] if created while mocking is enabled
      # @raise [ArgumentError] if a setting required by the provider was not passed in
      #
      # @example Minimal options (dependent on ~/.fog)
      #   @service = Fog::Compute::Example.new # => <#Fog::Compute::Example::Real>
      #
      # @example Mocked service
      #   Fog.mock!
      #   @service = Fog::Compute::Example.new # => <#Fog::Compute::Example::Mock>
      #
      # @example Configured using many options (options merged into ~/.fog)
      #   @options = {
      #     :example_username => "fog",
      #     :example_password => "fog"
      #   }
      #   @service = Fog::Compute::Example.new(@options)
      #
      # @example Configured using external config object (~/.fog ignored completely)
      #   @config = Fog::Example::Config.new(...)
      #   @service = Fog::Compute::Example.new(@config)
      #
      def new(config = {})
        if config.respond_to?(:config_service?) && config.config_service?
          cleaned_settings = config
        else
          cleaned_settings = handle_settings(config)
        end
        setup_requirements

        svc = service
        if Fog.mocking?
          while svc != Fog::Service
            service::Mock.send(:include, svc::Collections)
            svc = svc.superclass
          end
          service::Mock.new(cleaned_settings)
        else
          while svc != Fog::Service
            service::Real.send(:include, svc::Collections)
            svc = svc.superclass
          end
          service::Real.send(:include, service::NoLeakInspector)
          service::Real.new(cleaned_settings)
        end
      end

      def setup_requirements
        if superclass.respond_to?(:setup_requirements)
          superclass.setup_requirements
        end

        @required ||= false

        return false if @required

        require_models
        require_collections_and_define
        require_requests_and_mock
        @required = true
      end

      def mocked_requests
        @mocked_requests ||= []
      end

      private

      # This will attempt to require all request files declared in the service using fog"s DSL
      def require_requests_and_mock
        requests.each do |request|
          require_item(request, @request_path)
          if service::Mock.method_defined?(request.last)
            mocked_requests << request.last
          else
            service::Mock.module_eval <<-EOS, __FILE__, __LINE__
              def #{request.last}(*args)
                Fog::Mock.not_implemented
              end
            EOS
          end
        end
      end
    end
  end
end
