module Fog
  module Attributes
    class Association < Default
      attr_reader :collection_name

      def initialize(model, name, options)
        super
        @model.attributes.pop
        @collection_name = options[:collection_name]
      end
    end
  end
end