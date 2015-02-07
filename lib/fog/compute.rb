module Fog
  module Compute
    def self.servers
      servers = []
      providers.each do |provider|
        begin
          servers.concat(self[provider].servers)
        rescue # ignore any missing credentials/etc
        end
      end
      servers
    end
  end
end
