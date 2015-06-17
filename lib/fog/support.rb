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
        begin
          require "fog/#{provider}/support"
          begin
            Fog::Support.const_get(Fog.providers[provider])
          rescue
            Fog.const_get(Fog.providers[provider])::Support
          end.new(attributes)
        rescue
          raise ArgumentError, "#{provider} has no support service"
        end
      else
        raise ArgumentError, "#{provider} is not a recognized provider"
      end
    end

    def self.providers
      Fog.services[:support]
    end
  end
end
