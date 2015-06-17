module Fog
  module Network
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require "fog/network/storm_on_demand"
        return Fog::Network::StormOnDemand.new(attributes)
      elsif providers.include?(provider)
        begin
          require "fog/#{provider}/network"
          begin
            Fog::Network.const_get(Fog.providers[provider])
          rescue
            Fog.const_get(Fog.providers[provider])::Network
          end.new(attributes)
        rescue
          raise ArgumentError, "#{provider} has no network service"
        end
      else
        raise ArgumentError, "#{provider} is not a recognized provider"
      end
    end

    def self.providers
      Fog.services[:network]
    end
  end
end
