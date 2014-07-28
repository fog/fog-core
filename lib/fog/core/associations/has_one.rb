module Fog
  module Associations
    class HasOne < Default
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