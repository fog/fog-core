module Fog
  module Attributes
    class Hash < Default
      def create_setter
        if squash = options[:squash]
          model.class_eval <<-EOS, __FILE__, __LINE__
            def #{name}=(new_data)
              if new_data.is_a?(Hash)
                if new_data.has_key?(:'#{squash}')
                  attributes[:#{name}] = new_data[:'#{squash}']
                elsif new_data.has_key?("#{squash}")
                  attributes[:#{name}] = new_data["#{squash}"]
                else
                  attributes[:#{name}] = [ new_data ]
                end
              else
                 attributes[:#{name}] = new_data
              end
            end
          EOS
        else
          model.class_eval <<-EOS, __FILE__, __LINE__
            def #{name}=(new_#{name})
              attributes[:#{name}] = new_#{name}
            end
          EOS
        end
      end
    end
  end
end
