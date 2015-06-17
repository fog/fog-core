module Fog
  module Billing
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if provider == :stormondemand
        require "fog/billing/storm_on_demand"
        Fog::Billing::StormOnDemand.new(attributes)
      elsif providers.include?(provider)
        begin
          require "fog/#{provider}/billing"
          begin
            Fog::Account.const_get(Fog.providers[provider])
          rescue
            Fog.const_get(Fog.providers[provider])::Account
          end.new(attributes)
        rescue
          raise ArgumentError, "#{provider} has no billing service"
        end
      else
        raise ArgumentError, "#{provider} is not a recognized provider"
      end
    end

    def self.providers
      Fog.services[:billing]
    end
  end
end
