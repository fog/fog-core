module Fog
  module CDN
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if providers.include?(provider)
        require "fog/#{provider}/cdn"
        begin
          Fog::CDN.const_get(Fog.providers[provider])
        rescue
          Fog.const_get(Fog.providers[provider])::CDN
        end.new(attributes)
      else
        raise ArgumentError, "#{provider} has no cdn service"
      end
    end

    def self.providers
      Fog.services[:cdn]
    end
  end
end
