module Fog
  module CDN
    extend Fog::Core::ServiceAbstraction

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if providers.include?(provider)
        require "fog/#{provider}/cdn"
        return Fog::CDN.const_get(Fog.providers[provider]).new(attributes)
      end
      raise ArgumentError, "#{provider} is not a recognized cdn provider"
    end
  end
end
