module Fog
  module Metering
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if providers.include?(provider)
        require "fog/#{provider}/metering"
        begin
          Fog::Metering.const_get(Fog.providers[provider])
        rescue
          Fog.const_get(Fog.providers[provider])::Metering
        end.new(attributes)
      else
        raise ArgumentError, "#{provider} has no metering service"
      end
    end

    def self.providers
      Fog.services[:metering]
    end
  end
end
