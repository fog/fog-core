module Fog
  module Monitoring
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if provider == :stormondemand
        require "fog/monitoring/storm_on_demand"
        Fog::Monitoring::StormOnDemand.new(attributes)
      elsif providers.include?(provider)
        begin
          require "fog/#{provider}/monitoring"
          begin
            Fog::Monitoring.const_get(Fog.providers[provider])
          rescue
            Fog.const_get(Fog.providers[provider])::Monitoring
          end.new(attributes)
        rescue
          raise ArgumentError, "#{provider} has no monitoring service"
        end
      else
        raise ArgumentError, "#{provider} is not a recognized provider"
      end
    end

    def self.providers
      Fog.services[:monitoring]
    end
  end
end
