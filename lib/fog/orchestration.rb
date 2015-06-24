module Fog
  module Orchestration
    extend Fog::ServicesMixin

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if providers.include?(provider)
        begin
          require "fog/#{provider}/orchestration"
          begin
            Fog::Orchestration.const_get(Fog.providers[provider])
          rescue
            Fog.const_get(Fog.providers[provider])::Orchestration
          end.new(attributes)
        rescue
          raise ArgumentError, "#{provider} has no orchestration service"
        end
      else
        raise ArgumentError, "#{provider} is not a recognized provider"
      end
    end
  end
end
