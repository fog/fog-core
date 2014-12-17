module Fog
  module Support
    extend Fog::Core::ServiceAbstraction

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require "fog/support/storm_on_demand"
        Fog::Support::StormOnDemand.new(attributes)
      else
        raise ArgumentError, "#{provider} has no support service"
      end
    end
  end
end
