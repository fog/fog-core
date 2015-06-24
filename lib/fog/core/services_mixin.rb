module Fog
  module ServicesMixin
    def [](provider)
      new(:provider => provider)
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
