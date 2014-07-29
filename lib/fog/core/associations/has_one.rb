module Fog
  module Associations
    class HasOne < Default
      def create_setter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            associations[:#{name}] = new_#{name}
          end
        EOS
      end

      def create_getter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            return nil if associations[:#{name}].nil?
            if associations[:#{name}].respond_to?(:identity)
              associations[:#{name}]
            else
              service.send(self.class.associations[:#{name}]).get(associations[:#{name}])
            end
          end
        EOS
      end
    end
  end
end