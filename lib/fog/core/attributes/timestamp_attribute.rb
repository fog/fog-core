module Fog
  module Attributes
    class TimestampAttribute < DefaultAttribute
      def create_setter
        model.class_eval <<-EOS, __FILE__, __LINE__
            def #{name}=(new_#{name})
              if new_#{name}.respond_to?(:to_i)
                attributes[:#{name}] = Time.at(new_#{name}.to_i)
              else
                attributes[:#{name}] = Time.parse(new_#{name}.to_s)
              end
            end
        EOS
      end
    end
  end
end