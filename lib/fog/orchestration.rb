module Fog
  module Orchestration
    def self.[](provider)
      new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if providers.include?(provider)
        require "fog/#{provider}/orchestration"
        begin
          Fog::Orchestration.const_get(Fog.providers[provider])
        rescue
          Fog.const_get(Fog.providers[provider])::Orchestration
        end.new(attributes)
      else
        raise ArgumentError, "#{provider} has no orchestration service"
      end
    end

    def self.providers
      Fog.services[:orchestration]
    end
  end
end
