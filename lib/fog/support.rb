module Fog
  module Support
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require "fog/support/storm_on_demand"
        Fog::Support::StormOnDemand.new(attributes)
      elsif providers.include?(provider)
        require "fog/#{provider}/support"
        begin
          Fog::Support.const_get(Fog.providers[provider])
        rescue
          Fog.const_get(Fog.providers[provider])::Support
        end.new(attributes)
      else
        raise ArgumentError, "#{provider} has no support service"
      end
    end

    def self.providers
      Fog.services[:support]
    end
  end
end
