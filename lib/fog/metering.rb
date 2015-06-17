module Fog
  module Metering
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if providers.include?(provider)
        begin
          require "fog/#{provider}/metering"
          begin
            Fog::Metering.const_get(Fog.providers[provider])
          rescue
            Fog.const_get(Fog.providers[provider])::Metering
          end.new(attributes)
        rescue
          raise ArgumentError, "#{provider} has no metering service"
        end
      else
        raise ArgumentError, "#{provider} is not a recognized provider"
      end
    end

    def self.providers
      Fog.services[:metering]
    end
  end
end
