module Fog
  class << self
    attr_writer :providers
  end

  def self.providers
    @providers ||= {}
  end

  module Provider
    def self.extended(base)
      provider = base.to_s.split("::").last
      Fog.providers[provider.downcase.to_sym] = provider
    end

    def [](service_key)
      eval(@services_registry[service_key]).new
    end

    def service(new_service, constant_string)
      Fog.services[new_service] ||= []
      Fog.services[new_service] |= [to_s.split("::").last.downcase.to_sym]
      @services_registry ||= {}
      @services_registry[new_service] = service_klass(constant_string)
    end

    def services
      @services_registry.keys
    end

    def service_klass(constant_string)
      eval([to_s, constant_string].join("::"))
      [to_s, constant_string].join("::")
    rescue NameError
      provider = to_s.split("::").last
      Fog::Logger.deprecation("Unable to load #{[to_s, constant_string].join("::")}")
      Fog::Logger.deprecation("The format #{['Fog', constant_string, provider].join("::")} is deprecated")
      ['Fog', constant_string, provider].join("::")
    end
  end
end
