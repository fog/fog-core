module Fog
  module Associations
    class Many < Default
      def create_setter_for_identity
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            associations[:#{name}] = Array(new_#{name})
          end
        EOS
      end

      def create_getter_for_identity
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            return [] if associations[:#{name}].nil?
            Array(associations[:#{name}]).map do |association|
              service.send(self.class.associations[:#{name}]).get(association)
            end
          end
        EOS
      end

      def create_setter_for_object
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            associations[:#{name}] = Array(new_#{name})
          end
        EOS
      end

      def create_getter_for_object
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            Array(associations[:#{name}])
          end
        EOS
      end
    end
  end
end