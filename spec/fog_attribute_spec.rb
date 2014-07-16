require 'spec_helper'
require 'xmlrpc/datetime'

class FogAttributeTestModel < Fog::Model
  identity  :id
  attribute :key, :aliases => "keys", :squash => "id"
  attribute :time, :type => :time
  attribute :bool, :type => :boolean
  attribute :float, :type => :float
  attribute :integer, :type => :integer
  attribute :string, :type => :string
  attribute :timestamp, :type => :timestamp
  attribute :array, :type => :array
  attribute :default, :default => 'default_value'
end

describe "Fog::Attributes" do

  let(:model) { FogAttributeTestModel.new }

  it "should not create alias for nil" do
    FogAttributeTestModel.aliases.must_equal({ "keys" => :key })
  end

  describe "squash 'id'" do
    it "squashes if the key is a String" do
      model.merge_attributes("keys" => {:id => "value"})
      assert_equal"value", model.key
    end

    it "squashes if the key is a Symbol" do
      model.merge_attributes("keys" => {"id" => "value"})
      assert_equal "value", model.key
    end
  end

  describe ":type => time" do
    it "returns nil when provided nil" do
      model.merge_attributes(:time => nil)
      refute model.time
    end

    it "returns '' when provided ''" do
      model.merge_attributes(:time => "")
      assert_equal "",  model.time
    end

    it "returns a Time object when passed a Time object" do
      now = Time.now
      model.merge_attributes(:time => now.to_s)
      assert_equal Time.parse(now.to_s), model.time
    end

    it "returns a Time object when passed a XMLRPC::DateTime object" do
      now = XMLRPC::DateTime.new(2000, 7, 8, 10, 20, 34)
      model.merge_attributes(:time => now)
      assert_equal now.to_time, model.time
    end
  end

  describe ":type => :boolean" do
    it "returns the String 'true' as a boolean" do
      model.merge_attributes(:bool => "true")
      assert_equal true, model.bool
    end

    it "returns true as true" do
      model.merge_attributes(:bool => true)
      assert_equal true, model.bool
    end

    it "returns the String 'false' as a boolean" do
      model.merge_attributes(:bool => "false")
      assert_equal false, model.bool
    end

    it "returns false as false" do
      model.merge_attributes(:bool => false)
      assert_equal false, model.bool
    end

    it "returns a non-true/false value as nil" do
      model.merge_attributes(:bool => "foo")
      refute model.bool
    end
  end

  describe ":type => :float" do
    it "returns an integer as float" do
      model.merge_attributes(:float => 1)
      assert_in_delta 1.0, model.float
    end

    it "returns a string as float" do
      model.merge_attributes(:float => '1')
      assert_in_delta 1.0, model.float
    end
  end

  describe ":type => :integer" do
    it "returns a float as integer" do
      model.merge_attributes(:integer => 1.5)
      assert_in_delta 1, model.integer
    end

    it "returns a string as integer" do
      model.merge_attributes(:integer => '1')
      assert_in_delta 1, model.integer
    end
  end

  describe ":type => :string" do
    it "returns a float as string" do
      model.merge_attributes(:string => 1.5)
      assert_equal '1.5', model.string
    end

    it "returns a integer as string" do
      model.merge_attributes(:string => 1)
      assert_equal '1', model.string
    end
  end

  describe ":type => :timestamp" do
    it "returns a date as time" do
      model.merge_attributes(:timestamp => Date.new(2008, 10, 12))
      assert_equal '2008-10-12 00:00', model.timestamp.strftime('%Y-%m-%d %M:%S')
      assert_instance_of Fog::Time, model.timestamp
    end

    it "returns a time as time" do
      model.merge_attributes(:timestamp => Time.mktime(2007, 11, 1, 15, 25))
      assert_equal '2007-11-01 25:00', model.timestamp.strftime('%Y-%m-%d %M:%S')
      assert_instance_of Fog::Time, model.timestamp
    end

    it "returns a date_time as time" do
      model.merge_attributes(:timestamp => DateTime.new(2007, 11, 1, 15, 25, 0))
      assert_equal '2007-11-01 25:00', model.timestamp.strftime('%Y-%m-%d %M:%S')
      assert_instance_of Fog::Time, model.timestamp
    end
  end

  describe ":type => :array" do
    it "returns an empty array as an empty array" do
      model.merge_attributes(:array => [])
      assert_equal [], model.array
    end

    it "returns a single element as array" do
      model.merge_attributes(:array => 1.5)
      assert_equal [ 1.5 ], model.array
    end

    it "returns an array as array" do
      model.merge_attributes(:array => [ 1, 2 ])
      assert_equal [ 1, 2 ], model.array
    end
  end

  describe ":default => 'default_value'" do
    it "should return nil when default is not defined on a new object" do
      assert_equal model.bool, nil
    end

    it "should return the value of the object when default is not defined" do
      model.merge_attributes({ :bool => false })
      assert_equal model.bool, false
    end

    it "should return the default value on a new object" do
      assert_equal model.default, 'default_value'
    end

    it "should return the value of the persisted object" do
      model.merge_attributes({ :id => 'some-crazy-id', :default => 23 })
      assert_equal model.default, 23
    end

    it "should return nil on a persisted object without a value" do
      model.merge_attributes({ :id => 'some-crazy-id' })
      assert_equal model.default, nil
    end
  end
end
