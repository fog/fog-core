module Fog
  module Associations
    class Default
      attr_reader :model, :name, :aliases

      def initialize(model, name, collection_name, options)
        @model = model
        @name = name
        model.associations[name] = collection_name
        @aliases = options.fetch(:aliases, [])
        create_setter
        create_getter
        create_aliases
      end

      def create_aliases
        Array(aliases).each do |alias_name|
          model.aliases[alias_name] = name
        end
      end
    end
  end
end