module Fog
  # Fog::Formatador
  class Formatador
    extend Forwardable

    attr_accessor :object, :thread, :string, :formatador
    def_delegator :formatador, :indent, :indentation
 
    def initialize(obj, t)
      @object, @thread = obj, t
      thread[:formatador] ||= ::Formatador.new
      @formatador = thread[:formatador]
    end

    def to_s
      return string unless string.nil?
      init_string
      indent { string << object_string }
      (string << "#{indentation}>").dup
    end

    private 

    def init_string
      @string = "#{indentation}<#{object.class.name}\n"
    end

    def object_string
      "#{attribute_string}#{indentation}[#{nested_objects_string}"
    end

    def attribute_string
      if object.attributes.empty?
        "#{indentation}#{object_attributes}\n"
      else
        ""
      end
    end
 
   def nested_objects_string
      if object.empty?
        "\n#{inspect_nested}\n"
      else
        ""
      end
    end

    def object_attributes
      object.class.attributes.map do |attr|
        "#{attr}=#{send(attr).inspect}".join(",\n#{indentation}")
      end
    end

    def inspect_nested
      nested = ""
      indent do
        nested << map(&:inspect).join(", \n")
        nested << "\n"
      end
      nested << indentation
      nested
    end
  end
end
