# typed: true
module Parlour
  class RbsGenerator < Generator
    # A generic namespace. This shouldn't be used, except as the type of
    # {RbsGenerator#root}.
    class Namespace < RbsObject
      extend T::Sig
      extend T::Generic

      sig do
        override.overridable.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBS lines for this namespace.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBS lines, formatted as specified.
      def generate_rbs(indent_level, options)
        generate_comments(indent_level, options) +
          generate_body(indent_level, options)
      end

      sig do
        params(
          generator: Generator,
          name: T.nilable(String),
          block: T.nilable(T.proc.params(x: Namespace).void)
        ).void
      end
      # Creates a new namespace.
      # @note Unless you're doing something impressively hacky, this shouldn't
      #   be invoked outside of {RbsGenerator#initialize}.
      #
      # @param generator [RbsGenerator] The current RbsGenerator.
      # @param name [String, nil] The name of this module.
      # @param final [Boolean] Whether this namespace is final.
      # @param block A block which the new instance yields itself to.
      # @return [void]
      def initialize(generator, name = nil, &block)
        super(generator, name || '<anonymous namespace>')
        @children = []
        @next_comments = []
        yield_self(&block) if block
      end

      sig { override.returns(T::Array[RbsObject]).checked(:never) }
      # The child {RbsObject} instances inside this namespace.
      # @return [Array<RbsObject>]
      attr_reader :children

      include Mixin::Searchable
      Child = type_member {{ fixed: RbsObject }}

      sig { returns(T::Array[RbsGenerator::Extend]) }
      # The {RbsGenerator::Extend} objects from {children}.
      # @return [Array<RbsGenerator::Extend>]
      def extends
        T.cast(
          children.select { |c| c.is_a?(RbsGenerator::Extend) },
          T::Array[RbsGenerator::Extend]
        )
      end

      sig { returns(T::Array[RbsGenerator::Include]) }
      # The {RbsGenerator::Include} objects from {children}.
      # @return [Array<RbsGenerator::Include>]
      def includes
        T.cast(
          children.select { |c| c.is_a?(RbsGenerator::Include) },
          T::Array[RbsGenerator::Include]
        )
      end
      
      sig { returns(T::Array[RbsGenerator::TypeAlias]) }
      # The {RbsGenerator::TypeAlias} objects from {children}.
      # @return [Array<RbsGenerator::TypeAlias>]
      def aliases
        T.cast(
          children.select { |c| c.is_a?(RbsGenerator::TypeAlias) },
          T::Array[RbsGenerator::TypeAlias]
        )
      end
      alias type_aliases aliases

      sig { returns(T::Array[RbsGenerator::Constant]) }
      # The {RbsGenerator::Constant} objects from {children}.
      # @return [Array<RbsGenerator::Constant>]
      def constants
        T.cast(
          children.select { |c| c.is_a?(RbsGenerator::Constant) },
          T::Array[RbsGenerator::Constant]
        )
      end

      sig { params(object: T.untyped, block: T.proc.params(x: Namespace).void).void }
      # Given a Class or Module object, generates all classes and modules in the
      # path to that object, then executes the given block on the last
      # {Namespace}. This should only be executed on the root namespace.
      # @param [Class, Module] object
      # @param block A block which the new {Namespace} yields itself to.
      def path(object, &block)
        raise 'only call #path on root' if is_a?(ClassNamespace) || is_a?(ModuleNamespace)

        parts = object.to_s.split('::')
        parts_with_types = parts.size.times.map do |i|
          [parts[i], Module.const_get(parts[0..i].join('::')).class]
        end

        current_part = self
        parts_with_types.each do |(name, type)|
          if type == Class
            current_part = current_part.create_class(name)
          elsif type == Module
            current_part = current_part.create_module(name)
          else
            raise "unexpected type: path part #{name} is a #{type}"
          end
        end

        block.call(current_part)
      end

      sig { params(comment: T.any(String, T::Array[String])).void }
      # Adds one or more comments to the next child RBS object to be created.
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
          superclass: T.nilable(Types::TypeLike),
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
      # @param superclass [String, nil] The superclass of this class, or nil if it doesn't
      #   have one.
      # @param block A block which the new instance yields itself to.
      # @return [ClassNamespace]
      def create_class(name, superclass: nil, &block)
        new_class = ClassNamespace.new(generator, name, superclass, &block)
        move_next_comments(new_class)
        children << new_class
        new_class
      end

      sig do
        params(
          name: String,
          block: T.nilable(T.proc.params(x: Namespace).void)
        ).returns(ModuleNamespace)
      end
      # Creates a new module definition as a child of this namespace.
      #
      # @example Create a basic module.
      #   namespace.create_module('Foo')
      #
      # @param name [String] The name of this module.
      # @param block A block which the new instance yields itself to.
      # @return [ModuleNamespace]
      def create_module(name, &block)
        new_module = ModuleNamespace.new(generator, name, &block)
        move_next_comments(new_module)
        children << new_module
        new_module
      end

      sig do
        params(
          name: String,
          block: T.nilable(T.proc.params(x: Namespace).void)
        ).returns(InterfaceNamespace)
      end
      # Creates a new interface definition as a child of this namespace.
      #
      # @example Create a basic interface.
      #   namespace.create_interface('Foo')
      #
      # @param name [String] The name of this interface.
      # @param block A block which the new instance yields itself to.
      # @return [InterfaceNamespace]
      def create_interface(name, &block)
        new_interface = InterfaceNamespace.new(generator, name, &block)
        move_next_comments(new_interface)
        children << new_interface
        new_interface
      end

      sig do
        params(
          name: String,
          signatures: T.nilable(T::Array[MethodSignature]),
          class_method: T::Boolean,
          block: T.nilable(T.proc.params(x: Method).void)
        ).returns(Method)
      end
      # Creates a new method definition as a child of this namespace.
      #
      # @param name [String] The name of this method. You should not specify +self.+ in
      #   this - use the +class_method+ parameter instead.
      # @param signatures [Array<MethodSignature>] The signatures for each
      #   overload of this method.
      # @param class_method [Boolean] Whether this method is a class method; that is, it
      #   it is defined using +self.+.
      # @param block A block which the new instance yields itself to.
      # @return [Method]
      def create_method(name, signatures = nil, class_method: false, &block)
        raise 'cannot have a method with no signatures' if signatures&.empty?
        new_method = RbsGenerator::Method.new(
          generator,
          name,
          signatures || [MethodSignature.new([], nil)],
          class_method: class_method,
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
          block: T.nilable(T.proc.params(x: Attribute).void)
        ).returns(Attribute)
      end
      # Creates a new attribute.
      #
      # @example Create an +attr_reader+.
      #   module.create_attribute('readable', kind: :reader, type: 'String')
      #   # #=> attr_reader readable: String
      #
      # @example Create an +attr_writer+.
      #   module.create_attribute('writable', kind: :writer, type: 'Integer')
      #   # #=> attr_writer writable: Integer
      #
      # @example Create an +attr_accessor+.
      #   module.create_attribute('accessible', kind: :accessor, type: Types::Boolean.new)
      #   # #=> attr_accessor accessible: bool
      #
      # @param name [String] The name of this attribute.
      # @param kind [Symbol] The kind of attribute this is; one of +:writer+, +:reader+, or
      #   +:accessor+.
      # @param type [Types::TypeLike] This attribute's type.
      # @param class_attribute [Boolean] Whether this attribute belongs to the
      #   singleton class.
      # @param block A block which the new instance yields itself to.
      # @return [RbsGenerator::Attribute]
      def create_attribute(name, kind:, type:, &block)
        new_attribute = RbsGenerator::Attribute.new(
          generator,
          name,
          kind,
          type,
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
          block: T.nilable(T.proc.params(x: Attribute).void)
        ).returns(Attribute)
      end
      # Creates a new read-only attribute (+attr_reader+).
      #
      # @param name [String] The name of this attribute.
      # @param type [Types::TypeLike] This attribute's type.
      # @param class_attribute [Boolean] Whether this attribute belongs to the
      #   singleton class.
      # @param block A block which the new instance yields itself to.
      # @return [RbsGenerator::Attribute]
      def create_attr_reader(name, type:, &block)
        create_attribute(name, kind: :reader, type: type, &block)
      end

      sig do
        params(
          name: String,
          type: Types::TypeLike,
          block: T.nilable(T.proc.params(x: Attribute).void)
        ).returns(Attribute)
      end
      # Creates a new write-only attribute (+attr_writer+).
      #
      # @param name [String] The name of this attribute.
      # @param type [Types::TypeLike] This attribute's type.
      # @param class_attribute [Boolean] Whether this attribute belongs to the
      #   singleton class.
      # @param block A block which the new instance yields itself to.
      # @return [RbsGenerator::Attribute]
      def create_attr_writer(name, type:, &block)
        create_attribute(name, kind: :writer, type: type, &block)
      end

      sig do
        params(
          name: String,
          type: Types::TypeLike,
          block: T.nilable(T.proc.params(x: Attribute).void)
        ).returns(Attribute)
      end
      # Creates a new read and write attribute (+attr_accessor+).
      #
      # @param name [String] The name of this attribute.
      # @param type [Types::TypeLike] This attribute's type.
      # @param class_attribute [Boolean] Whether this attribute belongs to the
      #   singleton class.
      # @param block A block which the new instance yields itself to.
      # @return [RbsGenerator::Attribute]
      def create_attr_accessor(name, type:, &block)
        create_attribute(name, kind: :accessor, type: type, &block)
      end

      # Creates a new arbitrary code section.
      # You should rarely have to use this!
      #
      # @param code [String] The code to insert.
      # @param block A block which the new instance yields itself to.
      # @return [RbsGenerator::Arbitrary]
      def create_arbitrary(code:, &block)
        new_arbitrary = RbsGenerator::Arbitrary.new(
          generator,
          code: code,
          &block
        )
        move_next_comments(new_arbitrary)
        children << new_arbitrary
        new_arbitrary
      end

      sig { params(type: Types::TypeLike, block: T.nilable(T.proc.params(x: Extend).void)).returns(RbsGenerator::Extend) }
      # Adds a new +extend+ to this namespace.
      #
      # @example Add an +extend+ to a class.
      #   class.create_extend('ExtendableClass') #=> extend ExtendableClass
      #
      # @param type [Types::TypeLike] The type to extend.
      # @param block A block which the new instance yields itself to.
      # @return [RbsGenerator::Extend]
      def create_extend(type, &block)
        new_extend = RbsGenerator::Extend.new(
          generator,
          type: type,
          &block
        )
        move_next_comments(new_extend)
        children << new_extend
        new_extend
      end

      sig { params(extendables: T::Array[Types::TypeLike]).returns(T::Array[Extend]) }
      # Adds new +extend+s to this namespace.
      #
      # @example Add +extend+s to a class.
      #   class.create_extends(['Foo', 'Bar'])
      #
      # @param [Array<Types::TypeLike>] extendables An array of types to extend.
      # @return [Array<RbsGenerator::Extend>]
      def create_extends(extendables)
        returned_extendables = []
        extendables.each do |extendable|
          returned_extendables << create_extend(extendable)
        end
        returned_extendables
      end

      sig { params(type: Types::TypeLike, block: T.nilable(T.proc.params(x: Include).void)).returns(Include) }
      # Adds a new +include+ to this namespace.
      #
      # @example Add an +include+ to a class.
      #   class.create_include('IncludableClass') #=> include IncludableClass
      #
      # @param type [Types::TypeLike] The type to extend.
      # @param block A block which the new instance yields itself to.
      # @return [RbsGenerator::Include]
      def create_include(type, &block)
        new_include = RbsGenerator::Include.new(
          generator,
          type: type,
          &block
        )
        move_next_comments(new_include)
        children << new_include
        new_include
      end

      sig { params(includables: T::Array[Types::TypeLike]).returns(T::Array[Include]) }
      # Adds new +include+s to this namespace.
      #
      # @example Add +include+s to a class.
      #   class.create_includes(['Foo', 'Bar'])
      #
      # @param [Array<Types::TypeLike>] includables An array of types to extend.
      # @return [Array<RbsGenerator::Include>]
      def create_includes(includables)
        returned_includables = []
        includables.each do |includable|
          returned_includables << create_include(includable)
        end
        returned_includables
      end

      sig { params(name: String, type: Types::TypeLike, block: T.nilable(T.proc.params(x: Constant).void)).returns(Constant) }
      # Adds a new constant definition to this namespace.
      #
      # @example Add an +Elem+ constant to the class.
      #   class.create_constant('FOO', type: 'String') #=> FOO: String
      #
      # @param name [String] The name of the constant.
      # @param type [Types::TypeLike] The type of the constant, as a Ruby code string.
      # @param block A block which the new instance yields itself to.
      # @return [RbsGenerator::Constant]
      def create_constant(name, type:, &block)
        new_constant = RbsGenerator::Constant.new(
          generator,
          name,
          type: type,
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
      #   class.create_type_alias('MyType', type: 'Integer') #=> type MyType = Integer
      #
      # @param name [String] The name of the type alias.
      # @param value [Types::TypeLike] The type to alias.
      # @param block A block which the new instance yields itself to.
      # @return [RbsGenerator::TypeAlias]
      def create_type_alias(name, type:, &block)
        new_type_alias = TypeAlias.new(
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
          others: T::Array[RbsGenerator::RbsObject]
        ).returns(T::Boolean)
      end
      # Given an array of {Namespace} instances, returns true if they may be
      # merged into this instance using {merge_into_self}. All bare namespaces
      # can be merged into each other, as they lack definitions for themselves,
      # so there is nothing to conflict. (This isn't the case for subclasses
      # such as {ClassNamespace}.)
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other {Namespace} instances.
      # @return [true] Always true.
      def mergeable?(others)
        true
      end

      sig do
        override.overridable.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).void
      end
      # Given an array of {Namespace} instances, merges them into this one.
      # All children, constants, extends and includes are copied into this
      # instance.
      #
      # There may also be {RbsGenerator::Method} instances in the stream, which
      # are ignored.
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other {Namespace} instances.
      # @return [void]
      def merge_into_self(others)
        others.each do |other|
          next if other.is_a?(RbsGenerator::Method)
          other = T.cast(other, Namespace)

          other.children.each { |c| children << c }
        end
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        [:children]
      end

      private

      sig do
        overridable.params(
          indent_level: Integer,
          options: Options,
        ).returns(T::Array[String])
      end
      # Generates the RBS lines for the body of this namespace. This consists of
      # {includes}, {extends} and {children}.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @param mode [Symbol] The symbol to send to generate children: one of
      #   :generate_rbs or :generate_rbs.
      # @return [Array<String>] The RBS lines for the body, formatted as specified.
      def generate_body(indent_level, options)
        result = []

        if includes.any? || extends.any? || aliases.any? || constants.any?
          result += (options.sort_namespaces \
              ? includes.sort_by { |x| t = x.type; String === t ? t : t.generate_rbs }
              : includes)
            .flat_map { |x| x.generate_rbs(indent_level, options) }
            .reject { |x| x.strip == '' }
          result += (options.sort_namespaces \
              ? extends.sort_by { |x| t = x.type; String === t ? t : t.generate_rbs }
              : extends)
            .flat_map { |x| x.generate_rbs(indent_level, options) }
            .reject { |x| x.strip == '' }
          result += (options.sort_namespaces \
              ? aliases.sort_by { |x| t = x.type; String === t ? t : t.generate_rbs }
              : aliases)
            .flat_map { |x| x.generate_rbs(indent_level, options) }
            .reject { |x| x.strip == '' }
          result += (options.sort_namespaces \
              ? constants.sort_by { |x| t = x.type; String === t ? t : t.generate_rbs }
              : constants)
            .flat_map { |x| x.generate_rbs(indent_level, options) }
            .reject { |x| x.strip == '' }
          result << ""
        end

        # Sort children
        sorted_children = (
          if options.sort_namespaces
            # sort_by can be unstable (and is in current MRI).
            # Use the this work around to preserve order for ties
            children.sort_by.with_index { |child, i| [child.name, i] }
          else
            children
          end
        )        

        first, *rest = sorted_children.reject do |child|
          # We already processed these kinds of children
          child.is_a?(Include) || child.is_a?(Extend) || child.is_a?(Constant) || child.is_a?(TypeAlias)
        end.reject do |child|
          next if is_a?(ClassNamespace) || is_a?(ModuleNamespace) # next if this is not root
        
          if child.is_a?(RbsGenerator::Method)
            unless $VERBOSE.nil?
              print Rainbow("Parlour warning: ").yellow.dark.bold
              print Rainbow("RBS generation: ").magenta.bright.bold
              puts "RBS does not support top-level method definitions, ignoring #{child.name}"
              print Rainbow("    └ at object: ").blue.bright.bold
              puts describe       
            end  
            next true
          end

          false
        end
        unless first
          # Remove any trailing whitespace due to includes or class attributes
          result.pop while result.last == ''
          return result
        end

        result += first.generate_rbs(indent_level, options) + T.must(rest)
          .map { |obj| obj.generate_rbs(indent_level, options) }
          .map { |lines| [""] + lines }
          .flatten

        result
      end

      sig { params(object: RbsObject).void }
      # Copies the comments added with {#add_comment_to_next_child} into the
      # given object, and clears the list of pending comments.
      # @param object [RbsObject] The object to move the comments into.
      # @return [void]
      def move_next_comments(object)
        object.comments.unshift(*@next_comments)
        @next_comments.clear
      end
    end
  end
end
