module Fog
  module Whitelist

    def self.whitelist_keys(hash, valid_keys)
      valid_hash = self.stringify_keys(hash)
      valid_hash.select {|k,v| valid_keys.include?(k)}
    end

    private

    # http://devblog.avdi.org/2009/11/20/hash-transforms-in-ruby/
    def self.transform_hash(original, options={}, &block)
      original.inject({}){|result, (key,value)|
        value = if (options[:deep] && Hash === value)
                  transform_hash(value, options, &block)
                else
                  value
                end
        block.call(result,key,value)
        result
      }
    end

    # Returns a new hash with all keys converted to strings.
    def self.stringify_keys(hash)
      self.transform_hash(hash) {|hash, key, value|
        hash[key.to_s] = value
      }
    end

  end
end
