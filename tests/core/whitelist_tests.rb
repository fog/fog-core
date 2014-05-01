input_hash = {
  :name => 'test-server',
  :flavor => '123',
  :size => '12345'
}

output_hash = {
  'name' => 'test-server',
  'flavor' => '123'
}

valid_keys = %w{flavor name}

Shindo.tests('Fog::Whitelist', 'core') do

  tests('whitelist_keys') do
    tests('excludes invalid values') do
      returns(output_hash) {
        Fog::Whitelist.whitelist_keys(input_hash, valid_keys)
      }
    end
  end

end
