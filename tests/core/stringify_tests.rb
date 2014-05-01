input_hash = {
  :name => 'test-server',
  :flavor => '123'
}

output_hash = {
  'name' => 'test-server',
  'flavor' => '123'
}

Shindo.tests('Fog::Stringify', 'core') do

  tests('keys') do

    tests('stringifies symbols') do
      returns(output_hash) {
        Fog::Stringify.keys(input_hash)
      }
    end

    tests('skips strings') do
      returns(output_hash) {
        Fog::Stringify.keys(output_hash)
      }
    end

  end

end
