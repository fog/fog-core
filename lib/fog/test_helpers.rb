# So downstream users can use the test_helpers

helpers = Dir.glob(File.join(''test_helpers', '*helper.rb')).sort_by {|helper| helper.count(File::SEPARATOR)}
helpers.each do |h|
  load(h)
end
