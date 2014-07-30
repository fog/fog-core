module Fog
  module Associations
    class Default
      attr_reader :model, :name

      def initialize(model, name, collection_name)
        @model = model
        @name = name
        model.associations[name] = collection_name
        create_setter
        create_getter
      end
    end
  end
end