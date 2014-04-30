input_hash = {
  :name => 'test-server',
  :flavor => '123'
}

output_hash = {
  'name' => 'test-server',
  'flavor' => '123'
}

valid_keys = %w{flavor name}

Shindo.tests('Fog::Whitelist', 'core') do

  tests('stringify_keys') do

    tests('stringifies symbols') do
      returns(output_hash) {
        Fog::Whitelist.whitelist_keys(input_hash, valid_keys)
      }
    end

    tests('skips strings') do
      returns(output_hash) {
        Fog::Whitelist.whitelist_keys(output_hash, valid_keys)
      }
    end

  end

  tests('whitelist_keys') do

    hash_with_invalid_key = input_hash.merge(:size => '12345')

    tests('excludes invalid values') do
      returns(output_hash) {
        Fog::Whitelist.whitelist_keys(hash_with_invalid_key, valid_keys)
      }
    end

  end

end
