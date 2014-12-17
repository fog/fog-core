module Fog
  module Network
    extend Fog::Core::ServiceAbstraction

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require "fog/network/storm_on_demand"
        return Fog::Network::StormOnDemand.new(attributes)
      elsif providers.include?(provider)
        require "fog/#{provider}/network"
        return Fog::Network.const_get(Fog.providers[provider]).new(attributes)
      end

      raise ArgumentError, "#{provider} has no network service"
    end
  end
end
