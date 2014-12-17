module Fog
  module VPN
    extend Fog::Core::ServiceAbstraction

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require "fog/vpn/storm_on_demand"
        Fog::VPN::StormOnDemand.new(attributes)
      else
        raise ArgumentError, "#{provider} has no vpn service"
      end
    end
  end
end
