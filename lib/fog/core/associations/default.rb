module Fog
  module Associations
    class Default
      attr_reader :model, :name, :type

      def initialize(model, name, options)
        @model = model
        @name = name
        @type = options.fetch(:type, :object)
      end

      def create_setter
        return create_setter_for_object if type == :object
        create_setter_for_identity
      end

      def create_getter
        return create_getter_for_object if type == :object
        create_getter_for_identity
      end
    end
  end
end