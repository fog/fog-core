module Fog
  module Baremetal
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if providers.include?(provider)
        require "fog/#{provider}/baremetal"
        begin
          Fog::Baremetal.const_get(Fog.providers[provider])
        rescue
          Fog.const_get(Fog.providers[provider])::Baremetal
        end.new(attributes)
      else
        raise ArgumentError, "#{provider} has no baremetal service"
      end
    end

    def self.providers
      Fog.services[:baremetal]
    end
  end
end
