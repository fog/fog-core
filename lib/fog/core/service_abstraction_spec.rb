module Fog
  module Core
    module ServiceAbstractionSpec
      extend Minitest::Spec::DSL

      it "responds to #[]" do
        assert_respond_to subject, :[]
      end

      it "responds to #providers" do
        assert_respond_to subject, :providers
      end
    end
  end
end
