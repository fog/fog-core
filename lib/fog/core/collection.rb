require "fog/core/deprecated_connection_accessors"

module Fog
  # Fog::Collection
  class Collection < Array
    extend Fog::Attributes::ClassMethods
    include Fog::Attributes::InstanceMethods
    include Fog::Core::DeprecatedConnectionAccessors

    attr_reader :service

    Array.public_instance_methods(false).each do |method|
      next if [:reject, :select, :slice, :clear, :inspect].include?(method.to_sym)
      class_eval <<-EOS, __FILE__, __LINE__
        def #{method}(*args)
          unless @loaded
            lazy_load
          end
          super
        end
      EOS
    end

    %w(reject select slice).each do |method|
      class_eval <<-EOS, __FILE__, __LINE__
        def #{method}(*args)
          unless @loaded
            lazy_load
          end
          data = super
          self.clone.clear.concat(data)
        end
      EOS
    end

    def self.model(new_model = nil)
      if new_model.nil?
        @model
      else
        @model = new_model
      end
    end

    def clear
      @loaded = true && super
    end

    def create(attributes = {})
      object = new(attributes)
      object.save
      object
    end

    def destroy(identity)
      new(:identity => identity).destroy
    end

    # Creates a new Fog::Collection based around the passed service
    #
    # @param [Hash] attributes
    # @option attributes [Fog::Service] service Instance of a service
    #
    # @return [Fog::Collection]
    #
    def initialize(attributes = {})
      @service = attributes.delete(:service)
      @loaded = false
      merge_attributes(attributes)
    end

    def inspect
      Thread.current[:formatador] ||= Formatador.new
      Fog::Collection::Data.new(self, Thread.current).make
    end

    def load(objects)
      clear && objects.each { |object| self << new(object) }
      self
    end

    def model
      self.class.instance_variable_get("@model")
    end

    def new(attributes = {})
      unless attributes.is_a?(::Hash)
        raise ArgumentError, "Initialization parameters must be an attributes hash, got #{attributes.class} #{attributes.inspect}"
      end
      model.new(
        {
          :collection => self,
          :service => service
        }.merge(attributes)
      )
    end

    def reload
      clear && lazy_load
      self
    end

    def table(attributes = nil)
      Formatador.display_table(map(&:attributes), attributes)
    end

    def to_json(_options = {})
      Fog::JSON.encode(map(&:attributes))
    end

    private

    def lazy_load
      all
    end
  end
  # Base class for collection classes whose 'all' method returns only a single
  # page of results and passes the 'Marker' option along as
  # self.filters[:marker]
  class PagedCollection < Collection
    def each(collection_filters = filters)
      if block_given?
        Kernel.loop do
          break unless filters[:marker]
          page = all(collection_filters)
          # We need to explicitly use the base 'each' method here on the page,
          #  otherwise we get infinite recursion
          base_each = Fog::Collection.instance_method(:each)
          base_each.bind(page).call { |item| yield item }
        end
      end
      self
    end
  end

  # Data class for fog Collection
  class Data
    attr_accessor :collection, :thread, :data

    def initialize(obj, t)
      @collection, @thread = obj, t
      @data = "#{@thread[:formatador].indentation}<#{collection.class.name}\n"
    end

    def make
      @thread[:formatador].indent { append_data }
      @data << "#{thread[:formatador].indentation}>"
      @data.dup
    end

    def append_data
      add_attributes unless collection.class.attributes.empty?
      @data << ("#{thread[:formatador].indentation}[")
      add_stuff unless self.empty?
      @data << "]\n"
    end

    def add_params
      @data << "#{thread[:formatador].indentation}"
      add_attributes
      @data << "\n"
    end

    def add_attributes
      attrs = collection.class.attributes.map do |attr|
        str = "#{attr}=#{send(attr).inspect}"
        str.join(",\n#{thread[:formatador].indentation}")
      end
      @data << attrs
    end

    def add_stuff
      @data << "\n"
      @thread[:formatador].indent do
        @data << map(&:inspect).join(", \n")
        @data << "\n"
      end
      @data << @thread[:formatador].indentation
    end
  end
end
