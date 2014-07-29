module Fog
  module Associations
    class HasMany < Default
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
            return [] if associations[:#{name}].nil?
            associations[:#{name}].map do |association|
              if association.respond_to?(:identity)
                association
              else
                service.send(self.class.associations[:#{name}]).get(association)
              end
            end
          end
        EOS
      end
    end
  end
end