module Fog
  module Associations
    class Default
      attr_reader :model, :name

      def initialize(model, name, options = {})
        @model = model
        @name = name
      end
    end
  end
end