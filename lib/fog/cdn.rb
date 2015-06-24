module Fog
  module CDN
    extend Fog::ServicesMixin

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if providers.include?(provider)
        begin
          require "fog/#{provider}/cdn"
          begin
            Fog::CDN.const_get(Fog.providers[provider])
          rescue
            Fog.const_get(Fog.providers[provider])::CDN
          end.new(attributes)
        rescue
          raise ArgumentError, "#{provider} has no cdn service"
        end
      else
        raise ArgumentError, "#{provider} is not a recognized provider"
      end
    end
  end
end
