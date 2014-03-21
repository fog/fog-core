require_relative 'spec_helper'

class FogAttributeTestModel < Fog::Model
  attribute :key, :aliases => 'keys', :squash => "id"
  attribute :time, :type => :time
  attribute :bool, :type => :boolean
end

describe 'Fog::Attributes' do
  
  let(:model) { FogAttributeTestModel.new }

  describe "squash 'id'" do
    it "squashes if the key is a String" do
      model.merge_attributes("keys" => {:id => "value"})
      assert_equal"value", model.key
    end
      
    it "squashes if the key is a Symbol" do
      model.merge_attributes("keys" => {'id' => "value"})
      assert_equal "value", model.key
    end
  end
    
  describe ":type => time" do
    it "returns nil when provided nil" do
      model.merge_attributes(:time => nil)
      refute model.time
    end

    it "returns '' when provided ''" do
      model.merge_attributes(:time => '')
      assert_equal '',  model.time
    end

    it "returns a Time object when passed a Time object" do
      now = Time.now
      model.merge_attributes(:time => now.to_s)
      assert_equal Time.parse(now.to_s), model.time
    end
  end

  describe ':type => :boolean' do
    it "returns the String 'true' as a boolean" do
      model.merge_attributes(:bool => 'true')
      assert_equal true, model.bool
    end

    it "returns true as true" do
      model.merge_attributes(:bool => true)
      assert_equal true, model.bool
    end

    it "returns the String 'false' as a boolean" do
      model.merge_attributes(:bool => 'false')
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
end
