module Fog
  module Associations
    class One < Default
      def create_setter_for_identity
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            associations[:#{name}] = new_#{name}
          end
        EOS
      end

      def create_getter_for_identity
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            return nil if associations[:#{name}].nil?
            service.send(self.class.associations[:#{name}]).get(associations[:#{name}])
          end
        EOS
      end

      def create_setter_for_object
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            associations[:#{name}] = new_#{name}
          end
        EOS
      end

      def create_getter_for_object
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            associations[:#{name}]
          end
        EOS
      end
    end
  end
end