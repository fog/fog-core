module Fog
  module Identity

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      unless providers.include?(provider)
        raise ArgumentError.new("#{provider} has no identity service")
      end


      begin
        require "fog/#{provider}/identity"
        Fog::Identity.const_get(Fog.providers[provider]).new(attributes)
      rescue
        require "fog/identity/#{provider}"
        Fog::const_get(Fog.providers[provider]).const_get("Identity").new(attributes)
      end
    end

    def self.providers
      Fog.services[:identity]
    end
  end
end
