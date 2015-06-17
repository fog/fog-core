module Fog
  module VPN
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require "fog/vpn/storm_on_demand"
        Fog::VPN::StormOnDemand.new(attributes)
      elsif providers.include?(provider)
        begin
          require "fog/#{provider}/vpn"
          begin
            Fog::VPN.const_get(Fog.providers[provider])
          rescue
            Fog.const_get(Fog.providers[provider])::VPN
          end.new(attributes)
        rescue
          raise ArgumentError, "#{provider} has no vpn service"
        end
      else
        raise ArgumentError, "#{provider} is not a recognized provider"
      end
    end

    def self.providers
      Fog.services[:vpn]
    end
  end
end
