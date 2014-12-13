module Fog
  # Fog::Formatador
  class Formatador
    attr_accessor :object, :thread, :string

    def initialize(obj, t)
      raise ArgumentError, "#{t} is not a Thread" unless t.is_a? Thread
      @object, @thread = obj, t
      thread[:formatador] ||= ::Formatador.new
    end

    def to_s
      return string unless string.nil?
      init_string
      indent { string << object_string }
      (string << "#{indentation}>").dup
    end

    private

    def indent(&block)
      thread[:formatador].indent(&block)
    end

    def indentation
      thread[:formatador].indentation
    end

    def init_string
      @string = "#{indentation}<#{object.class.name}\n"
    end

    def object_string
      "#{attribute_string}#{nested_objects_string}"
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
        nested = "#{indentation}[\n"
        indent { nested << indentation + inspect_object }
        nested << "#{indentation}\n#{indentation}]\n"
        nested
      else
        ""
      end
    end

    def object_attributes
      attrs = object.class.attributes.map do |attr|
        "#{attr}=#{object.send(attr).inspect}"
      end
      attrs.join(",\n#{indentation}")
    end

    def inspect_object
      object.map { |o| indentation + o.inspect }.join(", \n#{indentation}")
    end
  end
end
