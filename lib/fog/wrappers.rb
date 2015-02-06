module Fog
  _modules = %w{Account Billing CDN Compute DNS Identity Image Metering Monitoring Network Orchestration Storage Support Volume VPN}
  _modules.each do |module_name|
    mod = Module.new do
      extend Fog::Core::ServiceAbstraction
    end
    Fog.const_set(module_name.to_sym, mod)
  end
end
