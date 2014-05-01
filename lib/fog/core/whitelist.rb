module Fog
  module Whitelist
    def self.whitelist_keys(hash, valid_keys)
      valid_hash = Stringify.keys(hash)
      valid_hash.select {|k,v| valid_keys.include?(k)}
    end
  end
end
