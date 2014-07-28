module Fog
  module Attributes
    class HasOne < Association
      attr_reader :collection_name

      def initialize(model, name, options)
        @model = model
        @name = name
        @collection_name = options[:collection_name]
      end

      def create_setter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            if new_#{name}.respond_to?(:identity)
              send("__#{name}=", new_#{name}.identity)
            else
              send("__#{name}=", new_#{name})
            end
          end
        EOS
      end

      def create_getter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            service.send("#{collection_name}").get(send("__#{name}"))
          end
        EOS
      end
    end
  end
end