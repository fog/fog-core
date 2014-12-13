require "spec_helper"

class TestCase < Fog::Collection
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

test_case_str = <<-EOL
  <TestCase
    this=["this", "that"],
    that=["that", "this"]
    [
      foo, 
      bar    
    ]
  >
EOL

test_case_str.chomp!

describe Fog::Formatador do

  def setup
    @formatador = Fog::Formatador.new(TestCase.new)
  end

  it "raises for missing required arguments" do
    assert_raises(ArgumentError) { Fog::Formatador.new }
  end

  it "should instansiate" do
    @formatador.must_be_instance_of Fog::Formatador
  end

  it "should respond to_s" do
    @formatador.must_respond_to :to_s
  end

  it "should give a string representation of object with proper indentation" do
    "#{@formatador}".must_equal test_case_str
  end
end
