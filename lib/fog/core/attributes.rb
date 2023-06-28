module Fog
  module Attributes
    module ClassMethods
      def _load(marshalled)
        new(Marshal.load(marshalled))
      end

      def aliases
        @aliases ||= {}
      end

      def associations
        @associations ||= {}
      end

      def attributes
        @attributes ||= []
      end

      def default_values
        @default_values ||= {}
      end

      def masks
        @masks ||= {}
      end

      # Defines a new attribute
      # @param [Symbol] name attribute name
      # @param [Hash] options (see {Default#initialize})
      # @option options [Symbol, ::String] :type attribute type (see {Attributes})
      # @option options [Symbol] :squash
      # @option options [::Array] :aliases
      # @option options [Object] :default
      # @option options [Object] :as
      def attribute(name, options = {})
        type = options.fetch(:type, "default").to_s.capitalize
        Fog::Attributes.const_get(type).new(self, name, options)
      end

      def has_one(name, collection_name, options = {})
        Fog::Associations::OneModel.new(self, name, collection_name, options)
      end

      def has_many(name, collection_name, options = {})
        Fog::Associations::ManyModels.new(self, name, collection_name, options)
      end

      def has_one_identity(name, collection_name, options = {})
        Fog::Associations::OneIdentity.new(self, name, collection_name, options)
      end

      def has_many_identities(name, collection_name, options = {})
        Fog::Associations::ManyIdentities.new(self, name, collection_name, options)
      end

      def identity(name, options = {})
        @identity = name
        attribute(name, options)
      end

      def ignore_attributes(*args)
        @ignored_attributes = args.map(&:to_s)
      end

      def ignored_attributes
        @ignored_attributes ||= []
      end
    end

    module InstanceMethods
      def _dump(_level)
        Marshal.dump(attributes)
      end

      def attributes
        @attributes ||= {}
      end

      def associations
        @associations ||= {}
      end

      def masks
        self.class.masks
      end

      def all_attributes
        self.class.attributes.reduce({}) do |hash, attribute|
          if masks[attribute].nil?
            Fog::Logger.deprecation("Please define #{attribute} using the Fog DSL")
            hash[attribute] = send(attribute)
          else
            hash[masks[attribute]] = send(attribute)
          end

          hash
        end
      end

      def all_associations
        self.class.associations.keys.reduce({}) do |hash, association|
          if masks[association].nil?
            Fog::Logger.deprecation("Please define #{association} using the Fog DSL")
            hash[association] = associations[association] || send(association)
          else
            hash[masks[association]] = associations[association] || send(association)
          end

          hash
        end
      end

      def all_associations_and_attributes
        all_attributes.merge(all_associations)
      end

      def dup
        copy = super
        copy.dup_attributes!
        copy
      end

      def identity_name
        self.class.instance_variable_get("@identity")
      end

      def identity
        send(identity_name)
      end

      def identity=(new_identity)
        send("#{identity_name}=", new_identity)
      end

      # Merges attributes into self
      # @note Ignored attributes are not merged (see {ClassMethods.ignored_attributes})
      # @return [self]
      def merge_attributes(new_attributes = {})
        new_attributes.each_pair do |key, value|
          next if self.class.ignored_attributes.include?(key)

          if self.class.aliases[key]
            send("#{self.class.aliases[key]}=", value)
          elsif self.respond_to?("#{key}=", true)
            send("#{key}=", value)
          else
            attributes[key] = value
          end
        end
        self
      end

      # Filters attributes by selected attribute names
      # @note In some cases we want to easily get subset of model attributes
      # @note Hash#slice requires Ruby >= 2.5.0
      # @param [Symbol] selected attribute names
      # @return [Hash] new hash with selected attributes
      def filter_attributes(*selected)
        filtered = attributes.select { |a, _| selected.include?(a) }

        # we should use getters instead of direct accessing attributes hash
        filtered.each_key { |k| filtered[k] = send(k) }
      end

      # Returns true if a remote resource has been assigned an
      # identity and we can assume it has been persisted.
      #
      # @return [Boolean]
      def persisted?
        !!identity
      end

      # Returns true if a remote resource has not been assigned an
      # identity.
      #
      # This was added for a ActiveRecord like feel but has been
      # outdated by ActiveModel API using {#persisted?}
      #
      # @deprecated Use inverted form of {#persisted?}
      # @return [Boolean]
      def new_record?
        Fog::Logger.deprecation("#new_record? is deprecated, use !persisted? instead [light_black](#{caller.first})[/]")
        !persisted?
      end

      # check that the attributes specified in args exist and is not nil
      def requires(*args)
        missing = missing_attributes(args)
        if missing.length == 1
          raise(ArgumentError, "#{missing.first} is required for this operation")
        elsif missing.any?
          raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
        end
      end

      def requires_one(*args)
        missing = missing_attributes(args)
        return unless missing.length == args.length

        raise(ArgumentError, "#{missing[0...-1].join(', ')} or #{missing[-1]} are required for this operation")
      end

      protected

      def missing_attributes(args)
        missing = []
        ([:service] | args).each do |arg|
          missing << arg unless send(arg.to_s) || attributes.key?(arg)
        end
        missing
      end

      def dup_attributes!
        @attributes = @attributes.dup if @attributes
      end

      private

      def remap_attributes(attributes, mapping)
        mapping.each_pair do |key, value|
          attributes[value] = attributes.delete(key) if attributes.key?(key)
        end
      end
    end
  end
end
