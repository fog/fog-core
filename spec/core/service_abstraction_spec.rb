require "spec_helper"
require "fog/core/service_abstraction_spec"

module Fog
  module ServiceAbstractionExample
    extend Fog::Core::ServiceAbstraction
  end
end

describe Fog::ServiceAbstractionExample do
  include Fog::Core::ServiceAbstractionSpec
  subject { Fog::ServiceAbstractionExample }
end
