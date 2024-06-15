require "spec_helper"
require "securerandom"

class FogTestModelForCollection < Fog::Model
  identity :id
end

class FogTestCollection < Fog::Collection
  model FogTestModelForCollection

  def all
    self
  end
end

describe Fog::Collection do
  describe "array delegation" do
    it "delegates methods with keywords to Array" do
      c = FogTestCollection.new
      c << FogTestModelForCollection.new(id: SecureRandom.hex)
      assert_equal c.sample(1, random: Random)[0], c[0]
    end
  end
end
