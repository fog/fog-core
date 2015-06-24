module Fog
  module ServicesMixin
    def [](provider)
      new(:provider => provider)
    end

    def new(attributes)
      attributes    = attributes.dup # Prevent delete from having side effects
      provider      = attributes.delete(:provider).to_s.downcase.to_sym
      provider_name = Fog.providers[provider]

      if providers.include?(provider)
        begin
          begin
            require "fog/#{provider}/#{service_name.downcase}"
          rescue LoadError
            require "fog/#{service_name.downcase}/#{provider}"
          end

          begin
            Fog.const_get(service_name).const_get(provider_name)
          rescue NameError  # Try to find the constant from in an alternate location
            Fog.const_get(provider_name).const_get(service_name)
          end.new(attributes)
        rescue
          raise ArgumentError, "#{provider} has no #{service_name.downcase} service"
        end
      else
        raise ArgumentError, "#{provider} is not a recognized provider"
      end
    end

    def providers
      Fog.services[service_name.downcase.to_sym] || []
    end

    private

    def service_name
      name.split("Fog::").last
    end
  end
end
