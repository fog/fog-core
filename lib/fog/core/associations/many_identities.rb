module Fog
  module Associations
    class ManyIdentities < Default
      def create_setter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            associations[:#{name}] = Array(new_#{name}).map do |association|
                                       association.respond_to?(:identity) ? association.identity : association
                                     end
          end
        EOS
      end

      def create_getter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            return [] if associations[:#{name}].nil?
            Array(associations[:#{name}]).map do |association|
              service.send(self.class.associations[:#{name}]).get(association)
            end
          end
        EOS
      end
    end
  end
end