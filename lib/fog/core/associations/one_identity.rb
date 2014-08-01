module Fog
  module Associations
    class OneIdentity < Default
      def create_setter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            associations[:#{name}] = new_#{name}.respond_to?(:identity) ? new_#{name}.identity : new_#{name}
          end
        EOS
      end

      def create_getter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            return nil if associations[:#{name}].nil?
            service.send(self.class.associations[:#{name}]).get(associations[:#{name}])
          end
        EOS
      end
    end
  end
end