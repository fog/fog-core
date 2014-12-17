module Fog
  module Account
    extend Fog::Core::ServiceAbstraction

    def self.new(attributes)
      attributes = attributes.dup
      provider = attributes.delete(:provider).to_s.downcase.to_sym

      if provider == :stormondemand
        require "fog/account/storm_on_demand"
        Fog::Account::StormOnDemand.new(attributes)
      else
        raise ArgumentError, "#{provider} has no account service"
      end
    end
  end
end
