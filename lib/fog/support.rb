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
      else
        raise ArgumentError, "#{provider} has no support service"
      end
    end

    def self.providers
      Fog.services[:support]
    end
  end
end
