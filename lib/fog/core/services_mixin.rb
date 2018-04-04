module Fog
  module ServicesMixin
    def [](provider)
      new(:provider => provider)
    end

    def new(attributes)
      attributes    = attributes.dup # Prevent delete from having side effects
      provider      = check_provider_alias(attributes.delete(:provider).to_s.downcase.to_sym)
      provider_name = Fog.providers[provider]

      raise ArgumentError, "#{provider} is not a recognized provider" unless providers.include?(provider)

      require_service_provider_library(service_name.downcase, provider)
      spc = service_provider_constant(service_name, provider_name)
      spc.new(attributes)
    rescue LoadError, NameError  # Only rescue errors in finding the libraries, allow connection errors through to the caller
      raise Fog::Service::NotFound, "#{provider} has no #{service_name.downcase} service"
    end

    def providers
      Fog.services[service_name.downcase.to_sym] || []
    end

    private

    # This method should be removed once all providers are extracted.
    # Bundler will correctly require all dependencies automatically and thus
    # fog-core wont need to know any specifics providers. Each provider will
    # have to load its dependencies.
    def require_service_provider_library(service, provider)
      require "fog/#{provider}/#{service}"
    rescue LoadError  # Try to require the service provider in an alternate location
      Fog::Logger.deprecation("Unable to require fog/#{provider}/#{service}")
      Fog::Logger.deprecation("The format fog/#{service}/#{provider} is deprecated")
      require "fog/#{service}/#{provider}"
    end

    def service_provider_constant(service_name, provider_name)
      Fog.const_get(provider_name).const_get(*const_get_args(service_name))
    rescue NameError  # Try to find the constant from in an alternate location
      Fog::Logger.deprecation("Unable to load Fog::#{provider_name}::#{service_name}")
      Fog::Logger.deprecation("The format Fog::#{service_name}::#{provider_name} is deprecated")
      Fog.const_get(service_name).const_get(*const_get_args(provider_name))
    end

    def const_get_args(*args)
      args + [false]
    end

    def service_name
      name.split("Fog::").last
    end

    def check_provider_alias(provider)
      case provider
      when :baremetalcloud
        Fog::Logger.deprecation(':baremetalcloud is deprecated. Use :bare_metal_cloud instead!')
        :bare_metal_cloud
      when :gogrid
        Fog::Logger.deprecation(':gogrid is deprecated. Use :go_grid instead!')
        :go_grid
      when :internetarchive
        Fog::Logger.deprecation(':internetarchive is deprecated. Use :internet_archive instead!')
        :internet_archive
      when :new_servers
        Fog::Logger.deprecation(':new_servers is deprecated. Use :bare_metal_cloud instead!')
        :bare_metal_cloud
      when :stormondemand
        Fog::Logger.deprecation(':stormondemand is deprecated. Use :storm_on_demand instead!')
        :storm_on_demand
      when :vclouddirector
        Fog::Logger.deprecation(':vclouddirector is deprecated. Use :vcloud_director instead!')
        :vcloud_director
      else provider
      end
    end
  end
end
