# typed: true
module Parlour
  class RbiGenerator < Generator
    # A generic namespace. This shouldn't be used, except as the type of
    # {RbiGenerator#root}.
    class Namespace < RbiObject
      extend T::Sig
      extend T::Generic

      sig do
        override.overridable.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBI lines for this namespace.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBI lines, formatted as specified.
      def generate_rbi(indent_level, options)
        generate_comments(indent_level, options) +
          generate_body(indent_level, options)
      end

      sig do
        params(
          generator: Generator,
          name: T.nilable(String),
          final: T::Boolean,
          sealed: T::Boolean,
          block: T.nilable(T.proc.params(x: Namespace).void)
        ).void
      end
      # Creates a new namespace.
      # @note Unless you're doing something impressively hacky, this shouldn't
      #   be invoked outside of {RbiGenerator#initialize}.
      #
      # @param generator [RbiGenerator] The current RbiGenerator.
      # @param name [String, nil] The name of this module.
      # @param final [Boolean] Whether this namespace is final.
      # @param final [Boolean] Whether this namespace is sealed.
      # @param block A block which the new instance yields itself to.
      # @return [void]
      def initialize(generator, name = nil, final = false, sealed = false, &block)
        super(generator, name || '<anonymous namespace>')
        @children = []
        @next_comments = []
        @final = final
        @sealed = sealed
        yield_self(&block) if block
      end

      sig { returns(T::Boolean) }
      # Whether this namespace is final.
      # @return [Boolean]
      attr_reader :final

      sig { returns(T::Boolean) }
      # Whether this namespace is sealed.
      # @return [Boolean]
      attr_reader :sealed

      sig { override.returns(T::Array[RbiObject]).checked(:never) }
      # The child {RbiObject} instances inside this namespace.
      # @return [Array<RbiObject>]
      attr_reader :children

      include Mixin::Searchable
      Child = type_member {{ fixed: RbiObject }}

      sig { returns(T::Array[RbiGenerator::Extend]) }
      # The {RbiGenerator::Extend} objects from {children}.
      # @return [Array<RbiGenerator::Extend>]
      def extends
        T.cast(
          children.select { |c| c.is_a?(RbiGenerator::Extend) },
          T::Array[RbiGenerator::Extend]
        )
      end

      sig { returns(T::Array[RbiGenerator::Include]) }
      # The {RbiGenerator::Include} objects from {children}.
      # @return [Array<RbiGenerator::Include>]
      def includes
        T.cast(
          children.select { |c| c.is_a?(RbiGenerator::Include) },
          T::Array[RbiGenerator::Include]
        )
      end

      sig { returns(T::Array[RbiGenerator::TypeAlias]) }
      # The {RbiGenerator::TypeAlias} objects from {children}.
      # @return [Array<RbiGenerator::TypeAlias>]
      def aliases
        T.cast(
          children.select { |c| c.is_a?(RbiGenerator::TypeAlias) },
          T::Array[RbiGenerator::TypeAlias]
        )
      end
      alias type_aliases aliases

      sig { returns(T::Array[RbiGenerator::Constant]) }
      # The {RbiGenerator::Constant} objects from {children}.
      # @return [Array<RbiGenerator::Constant>]
      def constants
        T.cast(
          children.select { |c| c.is_a?(RbiGenerator::Constant) },
          T::Array[RbiGenerator::Constant]
        )
      end

      sig { params(constant: Module, block: T.proc.params(x: Namespace).void).void }
      # Given a constant (i.e. a Module instance), generates all classes
      # and modules in the path to that object, then executes the given
      # block on the last {Namespace}. This should only be executed on
      # the root namespace.
      # @param [Module] constant
      # @param block A block which the new {Namespace} yields itself to.
      def path(constant, &block)
        raise 'only call #path on root' if is_a?(ClassNamespace) || is_a?(ModuleNamespace)

        constant_name = T.let(Module.instance_method(:name).bind(constant).call, T.nilable(String))
        raise 'given constant does not have a name' unless constant_name

        current_part = self
        constant_name.split('::').each_with_object([]) do |name, namespace|
          namespace << name
          instance = Module.const_get(namespace.join("::"))

          case instance
          when Class
            current_part = current_part.create_class(name)
          when Module
            current_part = current_part.create_module(name)
          else
            raise "unexpected type: path part #{name} is a #{instance.class}"
          end
        end

        block.call(current_part)
      end

      sig { params(comment: T.any(String, T::Array[String])).void }
      # Adds one or more comments to the next child RBI object to be created.
      #
      # @example Creating a module with a comment.
      #   namespace.add_comment_to_next_child('This is a module')
      #   namespace.create_module('M')
      #
      # @example Creating a class with a multi-line comment.
      #   namespace.add_comment_to_next_child(['This is a multi-line comment!', 'It can be as long as you want!'])
      #   namespace.create_class('C')
      #
      # @param comment [String, Array<String>] The new comment(s).
      # @return [void]
      def add_comment_to_next_child(comment)
        if comment.is_a?(String)
          @next_comments << comment
        elsif comment.is_a?(Array)
          @next_comments.concat(comment)
        end
      end

      sig do
        params(
          name: String,
          final: T::Boolean,
          sealed: T::Boolean,
          superclass: T.nilable(String),
          abstract: T::Boolean,
          block: T.nilable(T.proc.params(x: ClassNamespace).void)
        ).returns(ClassNamespace)
      end
      # Creates a new class definition as a child of this namespace.
      #
      # @example Create a class with a nested module.
      #   namespace.create_class('Foo') do |foo|
      #     foo.create_module('Bar')
      #   end
      #
      # @example Create a class that is the child of another class.
      #   namespace.create_class('Bar', superclass: 'Foo') #=> class Bar < Foo
      #
      # @param name [String] The name of this class.
      # @param final [Boolean] Whether this namespace is final.
      # @param sealed [Boolean] Whether this namespace is sealed.
      # @param superclass [String, nil] The superclass of this class, or nil if it doesn't
      #   have one.
      # @param abstract [Boolean] A boolean indicating whether this class is abstract.
      # @param block A block which the new instance yields itself to.
      # @return [ClassNamespace]
      def create_class(name, final: false, sealed: false, superclass: nil, abstract: false, &block)
        new_class = ClassNamespace.new(generator, name, final, sealed, superclass, abstract, &block)
        move_next_comments(new_class)
        children << new_class
        new_class
      end

      sig do
        params(
          name: String,
          final: T::Boolean,
          sealed: T::Boolean,
          enums: T.nilable(T::Array[T.any([String, String], String)]),
          abstract: T::Boolean,
          block: T.nilable(T.proc.params(x: EnumClassNamespace).void)
        ).returns(EnumClassNamespace)
      end
      # Creates a new enum class definition as a child of this namespace.
      #
      # @example Create a compass direction enum.
      #   namespace.create_class('Direction', enums: ['North', 'South', 'East', 'West'])
      #
      # @param name [String] The name of this class.
      # @param final [Boolean] Whether this namespace is final.
      # @param sealed [Boolean] Whether this namespace is sealed.
      # @param enums [Array<(String, String), String>] The values of the enumeration.
      # @param abstract [Boolean] A boolean indicating whether this class is abstract.
      # @param block A block which the new instance yields itself to.
      # @return [EnumClassNamespace]
      def create_enum_class(name, final: false, sealed: false, enums: nil, abstract: false, &block)
        new_enum_class = EnumClassNamespace.new(generator, name, final, sealed, enums || [], abstract, &block)
        move_next_comments(new_enum_class)
        children << new_enum_class
        new_enum_class
      end

      sig do
        params(
          name: String,
          final: T::Boolean,
          sealed: T::Boolean,
          props: T.nilable(T::Array[StructProp]),
          abstract: T::Boolean,
          block: T.nilable(T.proc.params(x: StructClassNamespace).void)
        ).returns(StructClassNamespace)
      end
      # Creates a new struct class definition as a child of this namespace.
      #
      # @example Create a person struct.
      #   namespace.create_class('Person', props: [
      #     Parlour::RbiGenerator::StructProp.new('name', 'String')
      #   ])
      #
      # @param name [String] The name of this class.
      # @param final [Boolean] Whether this namespace is final.
      # @param sealed [Boolean] Whether this namespace is sealed.
      # @param props [Array<StructProp>] The props of the struct.
      # @param abstract [Boolean] A boolean indicating whether this class is abstract.
      # @param block A block which the new instance yields itself to.
      # @return [EnumClassNamespace]
      def create_struct_class(name, final: false, sealed: false, props: nil, abstract: false, &block)
        new_struct_class = StructClassNamespace.new(generator, name, final, sealed, props || [], abstract, &block)
        move_next_comments(new_struct_class)
        children << new_struct_class
        new_struct_class
      end

      sig do
        params(
          name: String,
          final: T::Boolean,
          sealed: T::Boolean,
          interface: T::Boolean,
          abstract: T::Boolean,
          block: T.nilable(T.proc.params(x: ClassNamespace).void)
        ).returns(ModuleNamespace)
      end
      # Creates a new module definition as a child of this namespace.
      #
      # @example Create a basic module.
      #   namespace.create_module('Foo')
      #
      # @example Create a module with a method.
      #   namespace.create_module('Foo') do |foo|
      #     foo.create_method('method_name', parameters: [], return_type: 'Integer')
      #   end
      #
      # @param name [String] The name of this module.
      # @param final [Boolean] Whether this namespace is final.
      # @param sealed [Boolean] Whether this namespace is sealed.
      # @param interface [Boolean] A boolean indicating whether this module is an
      #   interface.
      # @param abstract [Boolean] A boolean indicating whether this module is
      #   abstract.
      # @param block A block which the new instance yields itself to.
      # @return [ModuleNamespace]
      def create_module(name, final: false, sealed: false, interface: false, abstract: false, &block)
        new_module = ModuleNamespace.new(generator, name, final, sealed, interface, abstract, &block)
        move_next_comments(new_module)
        children << new_module
        new_module
      end

      sig do
        params(
          name: String,
          parameters: T.nilable(T::Array[Parameter]),
          return_type: T.nilable(Types::TypeLike),
          returns: T.nilable(Types::TypeLike),
          abstract: T::Boolean,
          implementation: T::Boolean,
          override: T::Boolean,
          overridable: T::Boolean,
          class_method: T::Boolean,
          final: T::Boolean,
          type_parameters: T.nilable(T::Array[Symbol]),
          block: T.nilable(T.proc.params(x: Method).void)
        ).returns(Method)
      end
      # Creates a new method definition as a child of this namespace.
      #
      # @param name [String] The name of this method. You should not specify +self.+ in
      #   this - use the +class_method+ parameter instead.
      # @param parameters [Array<Parameter>] An array of {Parameter} instances representing this
      #   method's parameters.
      # @param return_type [String, nil] A Sorbet string of what this method returns, such as
      #   +"String"+ or +"T.untyped"+. Passing nil denotes a void return.
      # @param returns [String, nil] Same as return_type.
      # @param abstract [Boolean] Whether this method is abstract.
      # @param implementation [Boolean] DEPRECATED: Whether this method is an
      #   implementation of a parent abstract method.
      # @param override [Boolean] Whether this method is overriding a parent overridable
      #   method, or implementing a parent abstract method.
      # @param overridable [Boolean] Whether this method is overridable by subclasses.
      # @param class_method [Boolean] Whether this method is a class method; that is, it
      #   it is defined using +self.+.
      # @param final [Boolean] Whether this method is final.
      # @param type_parameters [Array<Symbol>, nil] This method's type parameters.
      # @param block A block which the new instance yields itself to.
      # @return [Method]
      def create_method(name, parameters: nil, return_type: nil, returns: nil, abstract: false, implementation: false, override: false, overridable: false, class_method: false, final: false, type_parameters: nil, &block)
        parameters = parameters || []
        raise 'cannot specify both return_type: and returns:' if return_type && returns
        return_type ||= returns
        new_method = RbiGenerator::Method.new(
          generator,
          name,
          parameters,
          return_type,
          abstract: abstract,
          implementation: implementation,
          override: override,
          overridable: overridable,
          class_method: class_method,
          final: final,
          type_parameters: type_parameters,
          &block
        )
        move_next_comments(new_method)
        children << new_method
        new_method
      end

      sig do
        params(
          name: String,
          kind: Symbol,
          type: Types::TypeLike,
          class_attribute: T::Boolean,
          block: T.nilable(T.proc.params(x: Attribute).void)
        ).returns(Attribute)
      end
      # Creates a new attribute.
      #
      # @example Create an +attr_reader+.
      #   module.create_attribute('readable', kind: :reader, type: 'String')
      #   # #=> sig { returns(String) }
      #   #     attr_reader :readable
      #
      # @example Create an +attr_writer+.
      #   module.create_attribute('writable', kind: :writer, type: 'Integer')
      #   # #=> sig { params(writable: Integer).returns(Integer) }
      #   #     attr_writer :writable
      #
      # @example Create an +attr_accessor+.
      #   module.create_attribute('accessible', kind: :accessor, type: 'T::Boolean')
      #   # #=> sig { returns(T::Boolean) }
      #   #     attr_accessor :accessible
      #
      # @example Create an +attr_accessor+ on the singleton class.
      #   module.create_attribute('singleton_attr', kind: :accessor, type: 'T::Boolean')
      #   # #=> class << self
      #   #       sig { returns(T::Boolean) }
      #   #       attr_accessor :singleton_attr
      #   #     end
      #
      # @param name [String] The name of this attribute.
      # @param kind [Symbol] The kind of attribute this is; one of +:writer+, +:reader+, or
      #   +:accessor+.
      # @param type [String] A Sorbet string of this attribute's type, such as
      #   +"String"+ or +"T.untyped"+.
      # @param class_attribute [Boolean] Whether this attribute belongs to the
      #   singleton class.
      # @param block A block which the new instance yields itself to.
      # @return [RbiGenerator::Attribute]
      def create_attribute(name, kind:, type:, class_attribute: false, &block)
        new_attribute = RbiGenerator::Attribute.new(
          generator,
          name,
          kind,
          type,
          class_attribute: class_attribute,
          &block
        )
        move_next_comments(new_attribute)
        children << new_attribute
        new_attribute
      end
      alias_method :create_attr, :create_attribute

      sig do
        params(
          name: String,
          type: Types::TypeLike,
          class_attribute: T::Boolean,
          block: T.nilable(T.proc.params(x: Attribute).void)
        ).returns(Attribute)
      end
      # Creates a new read-only attribute (+attr_reader+).
      #
      # @param name [String] The name of this attribute.
      # @param type [String] A Sorbet string of this attribute's type, such as
      #   +"String"+ or +"T.untyped"+.
      # @param class_attribute [Boolean] Whether this attribute belongs to the
      #   singleton class.
      # @param block A block which the new instance yields itself to.
      # @return [RbiGenerator::Attribute]
      def create_attr_reader(name, type:, class_attribute: false, &block)
        create_attribute(name, kind: :reader, type: type, class_attribute: class_attribute, &block)
      end

      sig do
        params(
          name: String,
          type: Types::TypeLike,
          class_attribute: T::Boolean,
          block: T.nilable(T.proc.params(x: Attribute).void)
        ).returns(Attribute)
      end
      # Creates a new write-only attribute (+attr_writer+).
      #
      # @param name [String] The name of this attribute.
      # @param type [String] A Sorbet string of this attribute's type, such as
      #   +"String"+ or +"T.untyped"+.
      # @param class_attribute [Boolean] Whether this attribute belongs to the
      #   singleton class.
      # @param block A block which the new instance yields itself to.
      # @return [RbiGenerator::Attribute]
      def create_attr_writer(name, type:, class_attribute: false, &block)
        create_attribute(name, kind: :writer, type: type, class_attribute: class_attribute, &block)
      end

      sig do
        params(
          name: String,
          type: Types::TypeLike,
          class_attribute: T::Boolean,
          block: T.nilable(T.proc.params(x: Attribute).void)
        ).returns(Attribute)
      end
      # Creates a new read and write attribute (+attr_accessor+).
      #
      # @param name [String] The name of this attribute.
      # @param type [String] A Sorbet string of this attribute's type, such as
      #   +"String"+ or +"T.untyped"+.
      # @param class_attribute [Boolean] Whether this attribute belongs to the
      #   singleton class.
      # @param block A block which the new instance yields itself to.
      # @return [RbiGenerator::Attribute]
      def create_attr_accessor(name, type:, class_attribute: false, &block)
        create_attribute(name, kind: :accessor, type: type, class_attribute: class_attribute, &block)
      end

      # Creates a new arbitrary code section.
      # You should rarely have to use this!
      #
      # @param code [String] The code to insert.
      # @param block A block which the new instance yields itself to.
      # @return [RbiGenerator::Arbitrary]
      def create_arbitrary(code:, &block)
        new_arbitrary = RbiGenerator::Arbitrary.new(
          generator,
          code: code,
          &block
        )
        move_next_comments(new_arbitrary)
        children << new_arbitrary
        new_arbitrary
      end

      sig { params(name: String, block: T.nilable(T.proc.params(x: Extend).void)).returns(RbiGenerator::Extend) }
      # Adds a new +extend+ to this namespace.
      #
      # @example Add an +extend+ to a class.
      #   class.create_extend('ExtendableClass') #=> extend ExtendableClass
      #
      # @param object [String] A code string for what is extended, for example
      #   +"MyModule"+.
      # @param block A block which the new instance yields itself to.
      # @return [RbiGenerator::Extend]
      def create_extend(name, &block)
        new_extend = RbiGenerator::Extend.new(
          generator,
          name: name,
          &block
        )
        move_next_comments(new_extend)
        children << new_extend
        new_extend
      end

      sig { params(extendables: T::Array[String]).returns(T::Array[Extend]) }
      # Adds new +extend+s to this namespace.
      #
      # @example Add +extend+s to a class.
      #   class.create_extends(['Foo', 'Bar'])
      #
      # @param [Array<String>] extendables An array of names for whatever is being extended.
      # @return [Array<RbiGenerator::Extend>]
      def create_extends(extendables)
        returned_extendables = []
        extendables.each do |extendable|
          returned_extendables << create_extend(extendable)
        end
        returned_extendables
      end

      sig { params(name: String, block: T.nilable(T.proc.params(x: Include).void)).returns(Include) }
      # Adds a new +include+ to this namespace.
      #
      # @example Add an +include+ to a class.
      #   class.create_include('IncludableClass') #=> include IncludableClass
      #
      # @param [String] name A code string for what is included, for example
      #   +"Enumerable"+.
      # @param block A block which the new instance yields itself to.
      # @return [RbiGenerator::Include]
      def create_include(name, &block)
        new_include = RbiGenerator::Include.new(
          generator,
          name: name,
          &block
        )
        move_next_comments(new_include)
        children << new_include
        new_include
      end

      sig { params(includables: T::Array[String]).returns(T::Array[Include]) }
      # Adds new +include+s to this namespace.
      #
      # @example Add +include+s to a class.
      #   class.create_includes(['Foo', 'Bar'])
      #
      # @param [Array<String>] includables An array of names for whatever is being included.
      # @return [Array<RbiGenerator::Include>]
      def create_includes(includables)
        returned_includables = []
        includables.each do |includable|
          returned_includables << create_include(includable)
        end
        returned_includables
      end

      sig { params(name: String, value: String, eigen_constant: T::Boolean, heredocs: T.nilable(String), block: T.nilable(T.proc.params(x: Constant).void)).returns(Constant) }
      # Adds a new constant definition to this namespace.
      #
      # @example Add an +Elem+ constant to the class.
      #   class.create_constant('Elem', value: 'String') #=> Elem = String
      #
      # @param name [String] The name of the constant.
      # @param value [String] The value of the constant, as a Ruby code string.
      # @param eigen_constant [Boolean] Whether this constant is defined on the
      #   eigenclass of the current namespace.
      # @param heredocs [String,nil] Values of the heredocs used, in order
      # @param block A block which the new instance yields itself to.
      # @return [RbiGenerator::Constant]
      def create_constant(name, value:, eigen_constant: false, heredocs: nil, &block)
        new_constant = RbiGenerator::Constant.new(
          generator,
          name: name,
          value: value,
          eigen_constant: eigen_constant,
          heredocs: heredocs,
          &block
        )
        move_next_comments(new_constant)
        children << new_constant
        new_constant
      end

      sig { params(name: String, type: Types::TypeLike, block: T.nilable(T.proc.params(x: TypeAlias).void)).returns(TypeAlias) }
      # Adds a new type alias, in the form of a constant, to this namespace.
      #
      # @example Add a +MyType+ type alias, to +Integer+, to the class.
      #   class.create_type_alias('MyType', type: 'Integer') #=> MyType = T.type_alias { Integer }
      #
      # @param name [String] The name of the type alias.
      # @param value [String] The type to alias, as a Ruby code string.
      # @param block A block which the new instance yields itself to.
      # @return [RbiGenerator::Constant]
      def create_type_alias(name, type:, &block)
        new_type_alias = RbiGenerator::TypeAlias.new(
          generator,
          name: name,
          type: type,
          &block
        )
        move_next_comments(new_type_alias)
        children << new_type_alias
        new_type_alias
      end

      sig do
        override.overridable.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).returns(T::Boolean)
      end
      # Given an array of {Namespace} instances, returns true if they may be
      # merged into this instance using {merge_into_self}. All bare namespaces
      # can be merged into each other, as they lack definitions for themselves,
      # so there is nothing to conflict. (This isn't the case for subclasses
      # such as {ClassNamespace}.)
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other {Namespace} instances.
      # @return [true] Always true.
      def mergeable?(others)
        true
      end

      sig do
        override.overridable.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).void
      end
      # Given an array of {Namespace} instances, merges them into this one.
      # All children, constants, extends and includes are copied into this
      # instance.
      #
      # There may also be {RbiGenerator::Method} instances in the stream, which
      # are ignored.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other {Namespace} instances.
      # @return [void]
      def merge_into_self(others)
        others.each do |other|
          next if other.is_a?(RbiGenerator::Method)
          other = T.cast(other, Namespace)

          other.children.each { |c| children << c }
        end
      end

      sig { override.void }
      def generalize_from_rbi!
        children.each(&:generalize_from_rbi!)
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        [:children, :final, :sealed]
      end

      private

      sig do
        overridable.params(
          indent_level: Integer,
          options: Options,
        ).returns(T::Array[String])
      end
      # Generates the RBI lines for the body of this namespace. This consists of
      # {includes}, {extends} and {children}.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBI lines for the body, formatted as specified.
      def generate_body(indent_level, options)
        result = []

        result += [options.indented(indent_level, 'final!'), ''] if final
        result += [options.indented(indent_level, 'sealed!'), ''] if sealed

        # Split away the eigen constants; these need to be put in a
        # "class << self" block later
        eigen_constants, non_eigen_constants = constants.partition(&:eigen_constant)
        eigen_constants.sort_by!(&:name) if options.sort_namespaces

        if includes.any? || extends.any? || aliases.any? || non_eigen_constants.any?
          result += (options.sort_namespaces ? includes.sort_by(&:name) : includes)
            .flat_map { |x| x.generate_rbi(indent_level, options) }
            .reject { |x| x.strip == '' }
          result += (options.sort_namespaces ? extends.sort_by(&:name) : extends)
            .flat_map { |x| x.generate_rbi(indent_level, options) }
            .reject { |x| x.strip == '' }
          result += (options.sort_namespaces ? aliases.sort_by(&:name) : aliases)
            .flat_map { |x| x.generate_rbi(indent_level, options) }
            .reject { |x| x.strip == '' }
          result += (options.sort_namespaces ? non_eigen_constants.sort_by(&:name) : non_eigen_constants)
            .flat_map { |x| x.generate_rbi(indent_level, options) }
            .reject { |x| x.strip == '' }
          result << ""
        end

        # Process singleton class attributes
        sorted_children = (
          if options.sort_namespaces
            # sort_by can be unstable (and is in current MRI).
            # Use the this work around to preserve order for ties
            children.sort_by.with_index { |child, i| [child.name, i] }
          else
            children
          end
        )
        class_attributes, remaining_children = sorted_children.partition do |child|
          child.is_a?(Attribute) && child.class_attribute
        end

        # Handle the "class << self block"
        result << options.indented(indent_level, 'class << self') \
          if class_attributes.any? || eigen_constants.any?

        if eigen_constants.any?
          first, *rest = eigen_constants
          result += T.must(first).generate_rbi(indent_level + 1, options) + T.must(rest)
            .map { |obj| obj.generate_rbi(indent_level + 1, options) }
            .map { |lines| [""] + lines }
            .flatten
        end

        result << '' if eigen_constants.any? && class_attributes.any?

        if class_attributes.any?
          first, *rest = class_attributes
          result += T.must(first).generate_rbi(indent_level + 1, options) + T.must(rest)
            .map { |obj| obj.generate_rbi(indent_level + 1, options) }
            .map { |lines| [""] + lines }
            .flatten
        end

        if class_attributes.any? || eigen_constants.any?
          result << options.indented(indent_level, 'end')
          result << ''
        end

        first, *rest = remaining_children.reject do |child|
          # We already processed these kinds of children
          child.is_a?(Include) || child.is_a?(Extend) || child.is_a?(Constant) || child.is_a?(TypeAlias)
        end
        unless first
          # Remove any trailing whitespace due to includes or class attributes
          result.pop while result.last == ''
          return result
        end

        result += first.generate_rbi(indent_level, options) + T.must(rest)
          .map { |obj| obj.generate_rbi(indent_level, options) }
          .map { |lines| [""] + lines }
          .flatten

        result
      end

      sig { params(object: RbiObject).void }
      # Copies the comments added with {#add_comment_to_next_child} into the
      # given object, and clears the list of pending comments.
      # @param object [RbiObject] The object to move the comments into.
      # @return [void]
      def move_next_comments(object)
        object.comments.unshift(*@next_comments)
        @next_comments.clear
      end
    end
  end
end
