module Fog
  module Identity

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attrs = attributes.dup # Prevent delete from having side effects
      provider = attrs.delete(:provider).to_s.downcase.to_sym
      raise ArgumentError.new("#{provider} has no identity service") unless self.providers.include?(provider)
      Fog::Identity.const_get(Fog.providers[provider]).new(attrs)
    end

    def self.providers
      Fog.services[:identity]
    end

  end
end
