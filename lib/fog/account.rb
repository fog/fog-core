module Fog
  module Account
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require "fog/account/storm_on_demand"
        Fog::Account::StormOnDemand.new(attributes)
      else
        raise ArgumentError, "#{provider} has no account service"
      end
    end

    def self.providers
      Fog.services[:account] || []
    end
  end
end
