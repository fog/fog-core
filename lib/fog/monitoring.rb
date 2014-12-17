module Fog
  module Monitoring
    extend Fog::Core::ServiceAbstraction

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym
      if provider == :stormondemand
        require "fog/monitoring/storm_on_demand"
        Fog::Monitoring::StormOnDemand.new(attributes)
      else
        raise ArgumentError, "#{provider} has no monitoring service"
      end
    end
  end
end
