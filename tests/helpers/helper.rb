# For shindo to be able to find everything at fog-core test execution time

helpers = Dir.glob(File.join('lib', 'fog', 'test_helpers', '*helper.rb')).sort_by {|helper| helper.count(File::SEPARATOR)}
helpers.each do |h|
  load(h)
end
