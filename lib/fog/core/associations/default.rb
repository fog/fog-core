module Fog
  module Associations
    class Default
      attr_reader :model, :name, :collection_name

      def initialize(model, name, options)
        @model = model
        @name = name
        @squash = options.fetch(:squash, false)
        @aliases = options.fetch(:aliases, [])
        @default = options[:default]
        @collection_name = options[:collection_name]
      end
    end
  end
end