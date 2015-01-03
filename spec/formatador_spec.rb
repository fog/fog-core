require "spec_helper"

class CollectionTestCase < Fog::Collection
  def all
  end
  def map(*_args)
    %w(foo bar)
  end

  def self.attributes
    %w(this that)
  end

  def this
    %w(this that)
  end

  def that
    %w(that this)
  end
end

class NonCollectionTestCase 
end

test_case_str1 = <<-EOL
  <CollectionTestCase
    this=["this", "that"],
    that=["that", "this"]
    [
      foo, 
      bar    
    ]
  >
EOL
test_case_str1.chomp!

test_case_str2 = <<-EOL
  <CollectionTestCase
    this=["this", "that"],
    that=["that", "this"]
  >
EOL
test_case_str2.chomp!

test_case_str3 = <<-EOL
  <NonCollectionTestCase
  >
EOL
test_case_str3.chomp!

describe Fog::Formatador do

  def setup
    @collection_test = CollectionTestCase.new
    @collection_test << 'this'
    @non_collection_test = NonCollectionTestCase.new
  end

  it "should give a string representation of object with proper indentation" do
    Fog::Formatador.format(@collection_test).must_equal test_case_str1
  end

  it 'should not include nested objects' do
    opts = { :include_nested => false }
    Fog::Formatador.format(@collection_test, opts).must_equal test_case_str2
  end 

  it 'should not raise if object does not response to :empty? or :map' do
    Fog::Formatador.format(@non_collection_test).must_equal test_case_str3
  end
end
