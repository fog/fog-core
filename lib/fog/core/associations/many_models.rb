module Fog
  module Associations
    # = Fog Multiple Association
    #
    # This class handles multiple association between the models.
    # It expects the provider to map the attribute with a collection of objects.
    class ManyModels < Default
      def create_setter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            associations[:#{name}] = Array(new_#{name})
          end
        EOS
      end

      def create_getter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            Array(associations[:#{name}])
          end
        EOS
      end
    end
  end
end
