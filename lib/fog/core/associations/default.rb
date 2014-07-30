module Fog
  module Associations
    class Default
      attr_reader :model, :name, :type

      def initialize(model, name, options)
        @model = model
        @name = name
        @type = options.fetch(:type, :object)
      end
    end
  end
end