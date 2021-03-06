module Islay
  module MetaData
    def self.included(klass)
      klass.class_eval do
        include InstanceMethods
        extend ClassMethods

        class_attribute :_metadata
      end
    end

    module InstanceMethods
      def data_column
        @data_column = self[_metadata.col] || {}
      end

      def metadata_attributes
        _metadata.attributes
      end

      def has_metadata?
        !!_metadata
      end
    end

    module ClassMethods
      def metadata(col, &blk)
        self._metadata = Attributes.new(self, col, &blk)
      end

      def add_metadata(col, &blk)
        self._metadata ||= Attributes.new(self, col)
        self._metadata.assign_attributes(&blk)
      end
    end

    class ExistingAttributeError < StandardError
      def initialize(col, model)
        @message = "Attribute :#{col} is already defined on the model #{model.to_s}"
      end

      def to_s
        @message
      end
    end

    class Attributes
      include Islay::Coercion

      attr_reader :col, :attributes

      def initialize(model, col, &blk)
        @col        = col
        @model      = model
        @attributes = {}

        assign_attributes(&blk)
      end

      def assign_attributes(&blk)
        instance_eval(&blk)
      end

      def foreign_key(name, opts = {})
        define_attribute(name, :foreign_key, :integer, opts)
      end

      def enum(name, opts = {})
        define_attribute(name, :enum, :string, opts)
      end

      def string(name, opts = {})
        define_attribute(name, :string, :string, opts)
      end

      def text(name, opts = {})
        define_attribute(name, :text, :string, opts)
      end

      def boolean(name, opts = {})
        define_attribute(name, :boolean, :boolean, opts)
      end

      # A non-normalized set of tags, returned as an array
      def tags(name, opts = {})
        define_attribute(name, :tags, :array, opts)
      end

      def date(name, opts = {})
        # Using composed of here is a dirty hack to get around a bug in
        # ActiveRecord i.e. MultiAttributeAssignmentError. A long lived and
        # still to be fixed issue. Derp.
        @model.class_eval do
          composed_of(
            name,
            :class_name   => 'Date',
            :mapping      => %w(Date to_s),
            :constructor  => Proc.new {|item| item },
            :converter    => Proc.new {|item| item }
          )
        end

        define_attribute(name, :date, :date, opts)
      end

      def integer(name, opts = {})
        define_attribute(name, :integer, :integer, opts)
      end

      def float(name, opts = {})
        define_attribute(name, :float, :float, opts)
      end

      # Defines an attribute which stores an instance of SpookAndPuff::Money
      #
      # @param Symbol name
      # @param Hash opts
      # @return nil
      def money(name, opts = {})
        define_attribute(name, :money, :money, opts)
      end

      def bitmask(name, opts = {})
        define_attribute(name, :bitmask, :integer, opts)
      end

      private

      def define_validations(name, type, primitive, opts)
        if opts[:required]
          @model.validates_presence_of(name)
        end

        if type != :bitmask
          if opts[:format]
            @model.validates_format_of(name, opts[:format])
          end

          if opts[:length]
            @model.validates_length_of(name, opts[:length])
          end

          if primitive == :integer || primitive == :float
            config = {}

            if primitive == :integer
              config[:only_integer] = true
            end

            if opts[:greater_than]
              config[:greater_than] = opts[:greater_than]
            end

            if opts[:less_than]
              config[:less_than] = opts[:less_than]
            end

            unless opts[:required]
              config[:allow_nil] = true
            end

            @model.validates_numericality_of(name, config)
          end

          if opts[:values] and type != :foreign_key
            values = opts[:values].is_a?(Hash) ? opts[:values].values : opts[:values]
            @model.validates_inclusion_of(name, :in => values, :allow_nil => true)
          end
        end
      end

      def define_attribute(name, type, primitive, opts)
        raise ExistingAttributeError.new(name, @model) if column_names.include?(name)

        reader = case primitive
        when :array
          %{
            if format == :string
              _metadata.coerce_#{primitive}(data_column['#{name}']).join(', ')
            else
              _metadata.coerce_#{primitive}(data_column['#{name}'])
            end
          }
        else
          case type
          when :bitmask
            %{ _metadata.read_bitmask(data_column['#{name}'], send(:#{opts[:values]}))}
          else
            %{ _metadata.coerce_#{primitive}(data_column['#{name}']) }
          end
        end

        writer = case primitive
        when :array
          %{
            self[_metadata.col] = data_column.merge('#{name}' => v)
          }
        else
           case type
           when :bitmask
             %{self[_metadata.col] = data_column.merge('#{name}' => _metadata.coerce_bitmask(v, send(:#{opts[:values]})))}
           else
             %{self[_metadata.col] = data_column.merge('#{name}' => _metadata.coerce_#{primitive}(v))}
           end
        end

        @model.class_eval %{

          def #{name}(format = :native)
            #{reader}
          end

          def #{name}=(v)
            #{writer}
          end
        }

        define_validations(name, type, primitive, opts)
        @attributes[name] = opts.merge!(:type => type)

        nil
      end

      def column_names
        @column_names ||= @model.columns.map {|c| c.name.to_sym}
      end
    end # Attributes
  end # MetaData
end #Islay
