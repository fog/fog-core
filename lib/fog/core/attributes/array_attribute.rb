module Fog
  module Attributes
    class ArrayAttribute < DefaultAttribute
      def create_setter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            attributes[:#{name}] = [*new_#{name}]
          end
        EOS
      end
    end
  end
end