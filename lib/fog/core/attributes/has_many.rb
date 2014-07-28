module Fog
  module Attributes
    class HasMany < HasOne
      def create_setter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            new_#{name} = Array(new_#{name})
            send("__#{name}=", [])
            new_#{name}.each do |association|
              if association.respond_to?(:identity)
                send("__#{name}").push(association.identity)
              else
                send("__#{name}").push(association)
              end
            end
          end
        EOS
      end

      def create_getter
        model.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            send("__#{name}").collect { |association| service.send("#{collection_name}").get(association) }
          end
        EOS
      end
    end
  end
end