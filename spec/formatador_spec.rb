require "spec_helper"

describe Fog::Formatador do
  describe "when object is Fog::Collection instance" do
    before do
      @member_class = Class.new(Fog::Model) do
        attribute :name

        def self.name
          "MemberGadget"
        end
      end

      @collection_class = Class.new(Fog::Collection) do
        model @member_class

        attribute :attr_one
        attribute :attr_two

        def self.name
          "InspectionGadget"
        end

        def all
          self
        end
      end

      @collection = @collection_class.new(:attr_one => "String", :attr_two => 5)
      @collection << @member_class.new(:name => "Member name")
      @expected = <<-EOS.gsub(/^ {6}/, "").chomp!
        <InspectionGadget
          attr_one=\"String\",
          attr_two=5
          [
                        <MemberGadget
              name=\"Member name\"
            >    
          ]
        >
      EOS
    end

    it "returns formatted representation" do
      Fog::Formatador.format(@collection).must_equal @expected
    end
  end

  describe "when object is Fog::Collection without attributes" do
    before do
      @collection_class = Class.new(Fog::Collection) do
        def all
          self
        end
      end

      @collection = @collection_class.new
      @expected = <<-EOS.gsub(/^ {6}/, "").chomp!
        <
          [
                
          ]
        >
      EOS
    end

    it "returns formatted representation" do
      Fog::Formatador.format(@collection).must_equal @expected
    end
  end

  describe "when object has is Fog::Collection but ignoring nested objects" do
    before do
      @collection_class = Class.new(Fog::Collection) do
        attribute :name

        def all
          self
        end
      end
      @collection = @collection_class.new(:name => "Name")
      @collection << "this"
    end

    it "returns formatted representation" do
      @expected = <<-EOS.gsub(/^ {6}/, "").chomp!
        <
          name=\"Name\"
        >
      EOS

      opts = { :include_nested => false }
      Fog::Formatador.format(@collection, opts).must_equal @expected
    end
  end

  describe "when object is not enumerable" do
    before do
      @class = Class.new
      @subject = @class.new
      @expected = <<-EOS.gsub(/^ {6}/, "").chomp!
        <
        >
      EOS
    end

    it "returns formatted representation" do
      Fog::Formatador.format(@subject).must_equal @expected
    end
  end
end
