require "inflecto"

module Fog
  module Core
    module ServiceAbstraction
      def providers
        Fog.services[service_symbol] || []
      end

      def [](provider)
        new(:provider => provider)
      end

      def new(attributes)
        attributes = attributes.dup # prevent delete from having side effects
        provider_code = attributes.delete(:provider).to_s.downcase.to_sym
        create_implementation_class(provider_code, attributes)
      end

      private

      def create_implementation_class(provider_code, attributes)
        if providers.include?(provider_code)
          begin
            require "fog/#{provider_require(provider_code)}/#{service_require}"
          rescue LoadError
            require "fog/#{service_require}/#{provider_require(provider_code)}"
          end

          implementation_class = implementation_class_name(provider_code)
          if implementation_class.respond_to?(:new)
            implementation_class.new(attributes)
          else
            # Need error handling when cause is found
            implementation_class.new(attributes)
          end
        else
          raise ArgumentError, "#{provider_code} is not a recognized #{service_symbol} provider"
        end
      end

      def implementation_class_name(provider_code)
        provider_class = Fog.providers[provider_code]
        class_name = "Fog::#{service_class}::#{provider_class}"
        unless const_defined?(class_name)
          class_name = "Fog::#{provider_class}::#{service_class}"
        end

        Inflecto.constantize(class_name)
      end

      # Returns the provider's name formatted for requiring.
      def provider_require(provider)
        # This is a list of awkward providers who did not use naming conventions
        {
          :baremetalcloud => :bare_metal_cloud,
          :vclouddirector => :vcloud_director,
          :gogrid => :go_grid,
          :internetarchive => :internet_archive,
          :stormondemand => :storm_on_demand
        }.fetch(provider, provider)
      end

      def service_class
        self.to_s.split("::").last
      end

      def service_require
        service_class.downcase
      end

      def service_symbol
        service_require.to_sym
      end
    end
  end
end
