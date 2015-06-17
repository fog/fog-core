module Fog
  module Volume
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if providers.include?(provider)
        require "fog/#{provider}/volume"
        begin
          Fog::Volume.const_get(Fog.providers[provider])
        rescue
          Fog.const_get(Fog.providers[provider])::Volume
        end.new(attributes)
      else
        raise ArgumentError, "#{provider} has no volume service"
      end
    end

    def self.providers
      Fog.services[:volume]
    end
  end
end
