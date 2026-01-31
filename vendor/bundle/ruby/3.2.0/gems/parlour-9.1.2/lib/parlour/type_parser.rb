# typed: true

# TODO: support sig without runtime

# Suppress versioning warnings - the majority of users will not actually be
# using this, so we don't want to pollute their console
old_verbose = $VERBOSE
begin
  $VERBOSE = nil
  require 'parser/current'
ensure
  $VERBOSE = old_verbose
end

module Parlour
  # Parses Ruby source to find Sorbet type signatures.
  class TypeParser
    # Represents a path of indices which can be traversed to reach a specific
    # node in an AST.
    class NodePath
      extend T::Sig

      sig { returns(T::Array[Integer]) }
      # @return [Array<Integer>] The path of indices.
      attr_reader :indices

      sig { params(indices: T::Array[Integer]).void }
      # Creates a new {NodePath}.
      #
      # @param [Array<Integer>] indices The path of indices.
      def initialize(indices)
        @indices = indices
      end

      sig { returns(NodePath) }
      # @return [NodePath] The parent path for the node at this path.
      def parent
        if indices.empty?
          raise IndexError, 'cannot get parent of an empty path'
        else
          NodePath.new(T.must(indices[0...-1]))
        end
      end

      sig { params(index: Integer).returns(NodePath) }
      # @param [Integer] index The index of the child whose path to return.
      # @return [NodePath] The path to the child at the given index.
      def child(index)
        NodePath.new(indices + [index])
      end

      sig { params(offset: Integer).returns(NodePath) }
      # @param [Integer] offset The sibling offset to use. 0 is the current
      #   node, -1 is the previous node, or 3 is is the node three nodes after
      #   this one.
      # @return [NodePath] The path to the sibling with the given context.
      def sibling(offset)
        if indices.empty?
          raise IndexError, 'cannot get sibling of an empty path'
        else
          *xs, x = indices
          x = T.must(x)
          raise ArgumentError, "sibling offset of #{offset} results in " \
            "negative index of #{x + offset}" if x + offset < 0
          NodePath.new(T.must(xs) + [x + offset])
        end
      end

      sig { params(start: Parser::AST::Node).returns(Parser::AST::Node) }
      # Follows this path of indices from an AST node.
      #
      # @param [Parser::AST::Node] start The AST node to start from.
      # @return [Parser::AST::Node] The resulting AST node.
      def traverse(start)
        current = T.unsafe(start)
        indices.each do |index|
          raise IndexError, 'path does not exist' if index >= current.to_a.length
          current = current.to_a[index]
        end
        current
      end
    end

    extend T::Sig

    sig { params(ast: Parser::AST::Node, unknown_node_errors: T::Boolean, generator: T.nilable(RbiGenerator)).void }
    # Creates a new {TypeParser} from whitequark/parser AST.
    #
    # @param [Parser::AST::Node] The AST.
    # @param [Boolean] unknown_node_errors Whether to raise an error if a node
    #   of an unknown kind is encountered. If false, the node is simply ignored;
    #   if true, a parse error is raised. Setting this to true is likely to
    #   raise errors for lots of non-RBI Ruby code, but setting it to false
    #   could miss genuine typed objects if Parlour or your code contains a bug.
    def initialize(ast, unknown_node_errors: false, generator: nil)
      @ast = ast
      @unknown_node_errors = unknown_node_errors
      @generator = generator || DetachedRbiGenerator.new
    end

    sig { params(filename: String, source: String, generator: T.nilable(RbiGenerator)).returns(TypeParser) }
    # Creates a new {TypeParser} from a source file and its filename.
    #
    # @param [String] filename A filename. This does not need to be an actual
    #   file; it merely identifies this source.
    # @param [String] source The Ruby source code.
    # @return [TypeParser]
    def self.from_source(filename, source, generator: nil)
      buffer = Parser::Source::Buffer.new(filename)
      buffer.source = source

      # || special case handles parser returning nil on an empty file
      parsed = Parser::CurrentRuby.new.parse(buffer) || Parser::AST::Node.new(:body)
      TypeParser.new(parsed, generator: generator)
    end

    sig { returns(Parser::AST::Node) }
    # @return [Parser::AST::Node] The AST which this type parser should use.
    attr_accessor :ast

    sig { returns(T::Boolean) }
    # @return [Boolean] Whether to raise an error if a node of an unknown kind
    #   is encountered.
    attr_reader :unknown_node_errors

    sig { returns(RbiGenerator) }
    # @return [RbiGenerator] The {RbiGenerator} to load the source into.
    attr_accessor :generator

    # Parses the entire source file and returns the resulting root namespace.
    #
    # @return [RbiGenerator::Namespace] The root namespace of the parsed source.
    sig { returns(RbiGenerator::Namespace) }
    def parse_all
      root = generator.root
      root.children.concat(parse_path_to_object(NodePath.new([])))
      root
    end

    # Given a path to a node in the AST, parses the object definitions it
    # represents and returns it, recursing to any child namespaces and parsing
    # any methods within.
    #
    # If the node directly represents several nodes, such as being a
    # (begin ...) node, they are all returned.
    #
    # @param [NodePath] path The path to the namespace definition. Do not pass
    #   any of the other parameters to this method in an external call.
    # @return [Array<RbiGenerator::RbiObject>] The objects the node at the path
    #    represents, parsed into an RBI generator object.
    sig { params(path: NodePath, is_within_eigenclass: T::Boolean).returns(T::Array[RbiGenerator::RbiObject]) }
    def parse_path_to_object(path, is_within_eigenclass: false)
      node = path.traverse(ast)

      case node.type
      when :class
        parse_err 'cannot declare classes in an eigenclass', node if is_within_eigenclass

        name, superclass, body = *node
        final = body_has_modifier?(body, :final!)
        sealed = body_has_modifier?(body, :sealed!)
        abstract = body_has_modifier?(body, :abstract!)
        includes, extends = body ? body_includes_and_extends(body) : [[], []]

        # Create all classes, if we're given a definition like "class A::B"
        *parent_names, this_name = constant_names(name)
        target = T.let(nil, T.nilable(RbiGenerator::Namespace))
        top_level = T.let(nil, T.nilable(RbiGenerator::Namespace))
        parent_names.each do |n|
          new_obj = RbiGenerator::Namespace.new(
            generator,
            n.to_s,
            false,
            false,
          )
          target.children << new_obj if target
          target = new_obj
          top_level ||= new_obj
        end if parent_names

        # Instantiate the correct kind of class
        if ['T::Struct', '::T::Struct'].include?(node_to_s(superclass))
          # Find all of this struct's props and consts
          # The body is typically a `begin` element but when there's only
          # one node there's no wrapping block and instead it would directly
          # be the node.
          prop_nodes = body.nil? ? [] :
            (body.type == :begin ? body.to_a : [body]).select { |x| x.type == :send && [:prop, :const].include?(x.to_a[1]) }

          props = prop_nodes.map do |prop_node|
            _, prop_type, name_node, type_node, extras_hash_node = *prop_node

            # "const" is just "prop ..., immutable: true"
            extras_hash = extras_hash_node.to_a.map do |pair_node|
              key_node, value_node = *pair_node
              parse_err 'prop/const key must be a symbol', prop_node unless key_node.type == :sym
              key = key_node.to_a.first

              value =
                if key == :default
                  T.must(node_to_s(value_node))
                else
                  case value_node.type
                  when :true
                    true
                  when :false
                    false
                  when :sym
                    value_node.to_a.first
                  else
                    T.must(node_to_s(value_node))
                  end
                end

              [key, value]
            end.to_h

            if prop_type == :const
              parse_err 'const cannot use immutable key', prop_node unless extras_hash[:immutable].nil?
              extras_hash[:immutable] = true
            end

            # Get prop/const name
            parse_err 'prop/const name must be a symbol or string', prop_node unless [:sym, :str].include?(name_node.type)
            name = name_node.to_a.first.to_s

            RbiGenerator::StructProp.new(
              name,
              T.must(node_to_s(type_node)),
              **T.unsafe(extras_hash)
            )
          end

          final_obj = RbiGenerator::StructClassNamespace.new(
            generator,
            this_name.to_s,
            final,
            sealed,
            props,
            abstract,
          )
        elsif ['T::Enum', '::T::Enum'].include?(node_to_s(superclass))
          # Look for (block (send nil :enums) ...) structure
          enums_node = body.nil? ? nil :
            (body.type == :begin ? body.to_a : [body]).find { |x| x.type == :block && x.to_a[0].type == :send && x.to_a[0].to_a[1] == :enums }

          # Find the constant assigments within this block
          # (If there's only one constant assignment, then that `casgn` node
          # will be a direct child, not wrapped in a body)
          enum_inner = enums_node.to_a[2]
          if enum_inner.nil?
            constant_nodes = []
          elsif enum_inner.type == :begin
            constant_nodes = enum_inner.to_a
          else
            constant_nodes = [enum_inner]
          end

          # Convert this to an array to enums as EnumClassNamespace expects
          enums = constant_nodes.map do |constant_node|
            _, name, new_node = *constant_node
            serialize_value = node_to_s(new_node.to_a[2])

            serialize_value ? [name.to_s, serialize_value] : name.to_s
          end

          final_obj = RbiGenerator::EnumClassNamespace.new(
            generator,
            this_name.to_s,
            final,
            sealed,
            enums,
            abstract,
          )
        else
          final_obj = RbiGenerator::ClassNamespace.new(
            generator,
            this_name.to_s,
            final,
            sealed,
            node_to_s(superclass),
            abstract,
          )
        end

        final_obj.children.concat(parse_path_to_object(path.child(2))) if body
        final_obj.create_includes(includes)
        final_obj.create_extends(extends)

        if target
          target.children << final_obj
          [T.must(top_level)]
        else
          [final_obj]
        end
      when :module
        parse_err 'cannot declare modules in an eigenclass', node if is_within_eigenclass

        name, body = *node
        abstract = body_has_modifier?(body, :abstract!)
        final = body_has_modifier?(body, :final!)
        sealed = body_has_modifier?(body, :sealed!)
        interface = body_has_modifier?(body, :interface!)
        includes, extends = body ? body_includes_and_extends(body) : [[], []]

        # Create all modules, if we're given a definition like "module A::B"
        *parent_names, this_name = constant_names(name)
        target = T.let(nil, T.nilable(RbiGenerator::Namespace))
        top_level = T.let(nil, T.nilable(RbiGenerator::Namespace))
        parent_names.each do |n|
          new_obj = RbiGenerator::Namespace.new(
            generator,
            n.to_s,
            false,
            false,
          )
          target.children << new_obj if target
          target = new_obj
          top_level ||= new_obj
        end if parent_names

        final_obj = RbiGenerator::ModuleNamespace.new(
          generator,
          this_name.to_s,
          final,
          sealed,
          interface,
          abstract,
        ) do |m|
          m.children.concat(parse_path_to_object(path.child(1))) if body
          m.create_includes(includes)
          m.create_extends(extends)
        end

        if target
          target.children << final_obj
          [T.must(top_level)]
        else
          [final_obj]
        end
      when :send, :block
        if sig_node?(node)
          parse_sig_into_methods(path, is_within_eigenclass: is_within_eigenclass)
        elsif node.type == :send &&
            [:attr_reader, :attr_writer, :attr_accessor].include?(node.to_a[1]) &&
            !previous_sibling_sig_node?(path)
          parse_method_into_methods(path, is_within_eigenclass: is_within_eigenclass)
        else
          []
        end
      when :def, :defs
        if previous_sibling_sig_node?(path)
          []
        else
          parse_method_into_methods(path, is_within_eigenclass: is_within_eigenclass)
        end
      when :sclass
        parse_err 'cannot access eigen of non-self object', node unless node.to_a[0].type == :self
        parse_path_to_object(path.child(1), is_within_eigenclass: true)
      when :begin
        # Just map over all the things
        node.to_a.length.times.map do |c|
          parse_path_to_object(path.child(c), is_within_eigenclass: is_within_eigenclass)
        end.flatten
      when :casgn
        _, name, body = *node

        # Determine whether this is a constant or a type alias
        # A type alias looks like:
        #   (block (send (const nil :T) :type_alias) (args) (type_to_alias))
        if body.type == :block &&
          body.to_a[0].type == :send &&
          body.to_a[0].to_a[0]&.type == :const &&
          body.to_a[0].to_a[0]&.to_a == [nil, :T] &&
          body.to_a[0].to_a[1] == :type_alias

          [Parlour::RbiGenerator::TypeAlias.new(
            generator,
            name: T.must(name).to_s,
            type: T.must(node_to_s(body.to_a[2])),
          )]
        else
          heredocs = find_heredocs(body)
          [Parlour::RbiGenerator::Constant.new(
            generator,
            name: T.must(name).to_s,
            value: T.must(node_to_s(body)),
            heredocs: heredocs
          )]
        end
      else
        if unknown_node_errors
          parse_err "don't understand node type #{node.type}", node
        else
          []
        end
      end
    end

    # A parsed sig, not associated with a method.
    class IntermediateSig < T::Struct
      prop :type_parameters, T.nilable(T::Array[Symbol])
      prop :overridable, T::Boolean
      prop :override, T::Boolean
      prop :abstract, T::Boolean
      prop :final, T::Boolean
      prop :return_type, T.nilable(String)
      prop :params, T.nilable(T::Array[Parser::AST::Node])
    end

    sig { params(body: T.nilable(Parser::AST::Node)).returns(T.nilable(String)) }
    # Given a node in the AST, finds all heredoc definitions within it
    # and return them as a String
    #
    # e.g., for the AST for following code:
    #
    #  foo = <<~HEREDOC
    #    bar
    #  HEREDOC
    #
    # this method would return "  bar\nHEREDOC\n"
    def find_heredocs(body)
      heredocs = T.let(nil, T.nilable(String))

      return heredocs if body.nil?

      loc = body.loc

      if loc.instance_of?(Parser::Source::Map::Heredoc)
        return body.loc.expression.source_buffer.source[loc.heredoc_body.begin_pos...loc.heredoc_end.end_pos]
      end

      body.children.map do |child|
        next unless child.instance_of?(Parser::AST::Node)

        child_heredocs = find_heredocs(child)

        next if child_heredocs.nil?

        heredocs ||= ''
        heredocs += child_heredocs
        heredocs += "\n"
      end

      heredocs
    end

    sig { params(path: NodePath).returns(IntermediateSig) }
    # Given a path to a sig in the AST, parses that sig into an intermediate
    # sig object.
    # This will raise an exception if the sig is invalid.
    # This is intended to be called by {#parse_sig_into_methods}, and shouldn't
    # be called manually unless you're doing something hacky.
    #
    # @param [NodePath] path The sig to parse.
    # @return [IntermediateSig] The parsed sig.
    def parse_sig_into_sig(path)
      sig_block_node = path.traverse(ast)

      # A sig's AST uses lots of nested nodes due to a deep call chain, so let's
      # flatten it out to make it easier to work with
      sig_chain = []
      current_sig_chain_node = sig_block_node.to_a[2]
      while current_sig_chain_node
        name = current_sig_chain_node.to_a[1]
        arguments = current_sig_chain_node.to_a[2..-1]

        sig_chain << [name, arguments]
        current_sig_chain_node = current_sig_chain_node.to_a[0]
      end

      # Get basic boolean flags
      override =    !!sig_chain.find { |(n, a)| n == :override    && a.empty? }
      overridable = !!sig_chain.find { |(n, a)| n == :overridable && a.empty? }
      abstract =    !!sig_chain.find { |(n, a)| n == :abstract    && a.empty? }

      # Determine whether this method is final (i.e. sig(:final))
      _, _, *sig_arguments = *sig_block_node.to_a[0]
      final = sig_arguments.any? { |a| a.type == :sym && a.to_a[0] == :final }

      # Find the return type by looking for a "returns" call
      return_type = sig_chain
        .find { |(n, _)| n == :returns }
        &.then do |(_, a)|
          parse_err 'wrong number of arguments in "returns" for sig', sig_block_node if a.length != 1
          node_to_s(a[0])
        end

      # Find the arguments specified in the "params" call in the sig
      sig_args = sig_chain
        .find { |(n, _)| n == :params }
        &.then do |(_, a)|
          parse_err 'wrong number of arguments in "params" for sig', sig_block_node if a.length != 1
          arg = a[0]
          parse_err 'argument to "params" should be a hash', arg unless arg.type == :hash
          arg.to_a
        end

      # Find type parameters if they were used
      type_parameters = sig_chain
        .find { |(n, _)| n == :type_parameters }
        &.then do |(_, a)|
          a.map do |arg|
            parse_err 'type parameter must be a symbol', arg if arg.type != :sym
            arg.to_a[0]
          end
        end

      IntermediateSig.new(
        type_parameters: type_parameters,
        overridable: overridable,
        override: override,
        abstract: abstract,
        final: final,
        params: sig_args,
        return_type: return_type
      )
    end

    sig { params(path: NodePath, is_within_eigenclass: T::Boolean).returns(T::Array[RbiGenerator::Method]) }
    # Given a path to a sig in the AST, finds the associated definition and
    # parses them into methods.
    # This will raise an exception if the sig is invalid.
    # Usually this will return one method; the only exception currently is for
    # attributes, where multiple can be declared in one call, e.g.
    # +attr_reader :x, :y, :z+.
    #
    # @param [NodePath] path The sig to parse.
    # @param [Boolean] is_within_eigenclass Whether the method definition this sig is
    #   associated with appears inside an eigenclass definition. If true, the
    #   returned method is made a class method. If the method definition
    #   is already a class method, an exception is thrown as the method will be
    #   a class method of the eigenclass, which Parlour can't represent.
    # @return [<RbiGenerator::Method>] The parsed methods.
    def parse_sig_into_methods(path, is_within_eigenclass: false)
      sig_block_node = path.traverse(ast)

      # A :def node represents a definition like "def x; end"
      # A :defs node represents a definition like "def self.x; end"
      def_node = path.sibling(1).traverse(ast)
      if def_node.type == :send && [:def, :defs].include?(def_node.children.last.type)
        # bypass inline modifier (e.g. "private")
        def_node = def_node.children.last
      end
      case def_node.type
      when :def
        class_method = false
        def_names = [def_node.to_a[0].to_s]
        def_params = def_node.to_a[1].to_a
        kind = :def
      when :defs
        parse_err 'targeted definitions on a non-self target are not supported', def_node \
          unless def_node.to_a[0].type == :self
        class_method = true
        def_names = [def_node.to_a[1].to_s]
        def_params = def_node.to_a[2].to_a
        kind = :def
      when :send
        target, method_name, *parameters = *def_node

        parse_err 'node after a sig must be a method definition', def_node \
          unless [:attr_reader, :attr_writer, :attr_accessor].include?(method_name) \
            || target != nil

        parse_err 'typed attribute should have at least one name', def_node if parameters&.length == 0

        kind = :attr
        attr_direction = method_name.to_s.gsub('attr_', '').to_sym
        def_names = T.must(parameters).map { |param| param.to_a[0].to_s }
        class_method = false
      else
        parse_err 'node after a sig must be a method definition', def_node
      end

      if is_within_eigenclass
        parse_err 'cannot represent multiple levels of eigenclassing', def_node if class_method
        class_method = true
      end

      this_sig = parse_sig_into_sig(path)
      params = this_sig.params
      return_type = this_sig.return_type

      if kind == :def
        # Sorbet allows a trailing blockarg that's not in the sig
        if params &&
           def_params.length == params.length + 1 &&
           def_params[-1].type == :blockarg
          def_params = def_params[0...-1]
        end

        parse_err 'mismatching number of arguments in sig and def', sig_block_node \
          if params && def_params.length != params.length

        # sig_args will look like:
        #   [(pair (sym :x) <type>), (pair (sym :y) <type>), ...]
        # def_params will look like:
        #   [(arg :x), (arg :y), ...]
        parameters = params \
          ? zip_by(params, ->x{ x.to_a[0].to_a[0] }, def_params, ->x{ x.to_a[0] })
            .map do |sig_arg, def_param|

              arg_name = def_param.to_a[0]

              # TODO: anonymous restarg
              full_name = arg_name.to_s
              full_name = "*#{arg_name}"  if def_param.type == :restarg
              full_name = "**#{arg_name}" if def_param.type == :kwrestarg
              full_name = "#{arg_name}:"  if def_param.type == :kwarg || def_param.type == :kwoptarg
              full_name = "&#{arg_name}"  if def_param.type == :blockarg

              default = def_param.to_a[1] ? node_to_s(def_param.to_a[1]) : nil
              type = node_to_s(sig_arg.to_a[1])

              RbiGenerator::Parameter.new(full_name, type: type, default: default)
            end
          : []

        # There should only be one ever here, but future-proofing anyway
        def_names.map do |def_name|
          RbiGenerator::Method.new(
            generator,
            def_name,
            parameters,
            return_type,
            type_parameters: this_sig.type_parameters,
            override: this_sig.override,
            overridable: this_sig.overridable,
            abstract: this_sig.abstract,
            final: this_sig.final,
            class_method: class_method
          )
        end
      elsif kind == :attr
        case attr_direction
        when :reader, :accessor
          parse_err "attr_#{attr_direction} sig should have no parameters", sig_block_node \
            if params && params.length > 0

          parse_err "attr_#{attr_direction} sig should have non-void return", sig_block_node \
            unless return_type

          attr_type = return_type
        when :writer
          # These are special and can only have one name
          raise 'typed attr_writer can only have one name' if def_names.length > 1

          def_name = def_names[0]
          parse_err "attr_writer sig should take one argument with the property's name", sig_block_node \
            if !params || params.length != 1 || params[0].to_a[0].to_a[0].to_s != def_name

          parse_err "attr_writer sig should have non-void return", sig_block_node \
            if return_type.nil?

          attr_type = T.must(node_to_s(params[0].to_a[1]))
        else
          raise "unknown attribute direction #{attr_direction}"
        end

        def_names.map do |def_name|
          RbiGenerator::Attribute.new(
            generator,
            def_name,
            attr_direction,
            attr_type,
            class_attribute: class_method
          )
        end
      else
        raise "unknown definition kind #{kind}"
      end
    end

    sig { params(path: NodePath, is_within_eigenclass: T::Boolean).returns(T::Array[RbiGenerator::Method]) }
    # Given a path to a method in the AST, finds the associated definition and
    # parses them into methods.
    # Usually this will return one method; the only exception currently is for
    # attributes, where multiple can be declared in one call, e.g.
    # +attr_reader :x, :y, :z+.
    #
    # @param [NodePath] path The sig to parse.
    # @param [Boolean] is_within_eigenclass Whether the method definition this sig is
    #   associated with appears inside an eigenclass definition. If true, the
    #   returned method is made a class method. If the method definition
    #   is already a class method, an exception is thrown as the method will be
    #   a class method of the eigenclass, which Parlour can't represent.
    # @return [<RbiGenerator::Method>] The parsed methods.
    def parse_method_into_methods(path, is_within_eigenclass: false)
      # A :def node represents a definition like "def x; end"
      # A :defs node represents a definition like "def self.x; end"
      def_node = path.traverse(ast)
      case def_node.type
      when :def
        class_method = false
        def_names = [def_node.to_a[0].to_s]
        def_params = def_node.to_a[1].to_a
        kind = :def
      when :defs
        parse_err 'targeted definitions on a non-self target are not supported', def_node \
          unless def_node.to_a[0].type == :self
        class_method = true
        def_names = [def_node.to_a[1].to_s]
        def_params = def_node.to_a[2].to_a
        kind = :def
      when :send
        target, method_name, *parameters = *def_node

        parse_err 'node after a sig must be a method definition', def_node \
          unless [:attr_reader, :attr_writer, :attr_accessor].include?(method_name) \
            || target != nil

        parse_err 'typed attribute should have at least one name', def_node if parameters&.length == 0

        kind = :attr
        attr_direction = method_name.to_s.gsub('attr_', '').to_sym
        def_names = T.must(parameters).map { |param| param.to_a[0].to_s }
        class_method = false
      else
        parse_err 'node after a sig must be a method definition', def_node
      end

      if is_within_eigenclass
        parse_err 'cannot represent multiple levels of eigenclassing', def_node if class_method
        class_method = true
      end

      return_type = unless def_names == ["initialize"]
        "T.untyped"
      end

      if kind == :def
        parameters = def_params.map do |def_param|
          arg_name = def_param.to_a[0]

          # TODO: anonymous restarg
          full_name = arg_name.to_s
          full_name = "*#{arg_name}"  if def_param.type == :restarg
          full_name = "**#{arg_name}" if def_param.type == :kwrestarg
          full_name = "#{arg_name}:"  if def_param.type == :kwarg || def_param.type == :kwoptarg
          full_name = "&#{arg_name}"  if def_param.type == :blockarg

          default = def_param.to_a[1] ? node_to_s(def_param.to_a[1]) : nil
          type = nil

          RbiGenerator::Parameter.new(full_name, type: type, default: default)
        end

        # There should only be one ever here, but future-proofing anyway
        def_names.map do |def_name|
          RbiGenerator::Method.new(
            generator,
            def_name,
            parameters,
            return_type,
            class_method: class_method
          )
        end
      elsif kind == :attr
        case attr_direction
        when :reader, :accessor, :writer
          attr_type = return_type || "T.untyped"
        else
          raise "unknown attribute direction #{attr_direction}"
        end

        def_names.map do |def_name|
          RbiGenerator::Attribute.new(
            generator,
            def_name,
            attr_direction,
            attr_type,
            class_attribute: class_method
          )
        end
      else
        raise "unknown definition kind #{kind}"
      end
    end

    sig { params(str: String).returns(Types::Type) }
    # TODO doc
    def self.parse_single_type(str)
      i = TypeParser.from_source('(none)', str)
      i.parse_node_to_type(i.ast)
    end

    sig { params(node: Parser::AST::Node).returns(Types::Type) }
    # Given an AST node representing an RBI type (such as 'T::Array[String]'),
    # parses it into a generic type.
    #
    # @param [Parser::AST::Node] node
    # @return [Parlour::Types::Type]
    def parse_node_to_type(node)
      case node.type
      when :send
        target, message, *args = *node

        # Special case: is this a generic type instantiation?
        if message == :[]
          names = constant_names(target)
          known_single_element_collections = [:Array, :Set, :Range, :Enumerator, :Enumerable]

          if names.length == 2 && names[0] == :T &&
            known_single_element_collections.include?(names[1])

            parse_err "no type in T::#{names[1]}[...]", node if args.nil? || args.empty?
            parse_err "too many types in T::#{names[1]}[...]", node unless args.length == 1
            return T.must(Types.const_get(T.must(names[1]))).new(parse_node_to_type(T.must(args.first)))
          elsif names.length == 2 && names == [:T, :Hash]
            parse_err "not enough types in T::Hash[...]", node if args.nil? || args.length < 2
            parse_err "too many types in T::Hash[...]", node unless args.length == 2
            return Types::Hash.new(
              parse_node_to_type(args[0]), parse_node_to_type(args[1])
            )
          else
            type = names.join('::')
            if args.nil?
              parse_err(
                "user defined generic '#{type}' requires at least one type parameter",
                node
              )
            end
            return Types::Generic.new(
              type,
              args.map { |arg| parse_node_to_type(arg) }
            )
          end
        end

        # Special case: is this a proc?
        # This parsing is pretty simplified, but you'd also have to be doing
        # something pretty cursed with procs to break this
        # This checks for (send (send (send (const nil :T) :proc) ...) ...)
        # That's the right amount of nesting for T.proc.params(...).returns(...)
        if node.to_a[0].type == :send &&
          node.to_a[0].to_a[0].type == :send &&
          node.to_a[0].to_a[0].to_a[1] == :proc &&
          node.to_a[0].to_a[0].to_a[0].type == :const &&
          node.to_a[0].to_a[0].to_a[0].to_a == [nil, :T] # yuck

          # Get parameters
          params_send = node.to_a[0]
          parse_err "expected 'params' to follow 'T.proc'", node unless params_send.to_a[1] == :params
          parse_err "expected 'params' to have kwargs", node unless params_send.to_a[2].type == :hash

          parameters = params_send.to_a[2].to_a.map do |pair|
            name, value = *pair
            parse_err "expected 'params' name to be symbol", node unless name.type == :sym
            name = name.to_a[0].to_s
            value = parse_node_to_type(value)

            RbiGenerator::Parameter.new(name, type: value)
          end

          # Get return value
          if node.to_a[1] == :void
            return_type = nil
          else
            _, call, *args = *node
            parse_err 'expected .returns or .void', node unless call == :returns
            parse_err 'no argument to .returns', node if args.nil? || args.empty?
            parse_err 'too many arguments to .returns', node unless args.length == 1
            return_type = parse_node_to_type(T.must(args.first))
          end

          return Types::Proc.new(parameters, return_type)
        end

        # The other options for a valid call are all "T.something" methods
        parse_err "unexpected call #{node_to_s(node).inspect} in type", node \
          unless target.type == :const && target.to_a == [nil, :T]

        case message
        when :nilable
          parse_err 'no argument to T.nilable', node if args.nil? || args.empty?
          parse_err 'too many arguments to T.nilable', node unless args.length == 1
          Types::Nilable.new(parse_node_to_type(T.must(args.first)))
        when :any
          Types::Union.new((args || []).map { |x| parse_node_to_type(T.must(x)) })
        when :all
          Types::Intersection.new((args || []).map { |x| parse_node_to_type(T.must(x)) })
        when :let
          # Not really allowed in a type signature, but handy for generalizing
          # constant types
          parse_err 'not enough argument to T.let', node if args.nil? || args.length < 2
          parse_err 'too many arguments to T.nilable', node unless args.length == 2
          parse_node_to_type(args[1])
        when :type_parameter
          parse_err 'no argument to T.type_parameter', node if args.nil? || args.empty?
          parse_err 'too many arguments to T.type_parameter', node unless args.length == 1
          parse_err 'expected T.type_parameter to be passed a symbol', node unless T.must(args.first).type == :sym
          Types::Raw.new(T.must(args.first.to_a[0].to_s))
        when :class_of
          parse_err 'no argument to T.class_of', node if args.nil? || args.empty?
          parse_err 'too many arguments to T.class_of', node unless args.length == 1
          Types::Class.new(parse_node_to_type(args[0]))
        when :untyped
          parse_err 'T.untyped does not accept arguments', node if !args.nil? && !args.empty?
          Types::Untyped.new
        else
          warning "unknown method T.#{message}, treating as untyped", node
          Types::Untyped.new
        end
      when :const
        # Special case: T::Boolean
        if constant_names(node) == [:T, :Boolean]
          return Types::Boolean.new
        end

        # Otherwise, just a plain old constant
        Types::Raw.new(constant_names(node).join('::'))
      when :array
        # Tuple
        Types::Tuple.new(node.to_a.map { |x| parse_node_to_type(T.must(x)) })
      when :hash
        # Shape/record
        keys_to_types = node.to_a.map do |pair|
          key, value = *pair
          parse_err "all shape keys must be symbols", node unless key.type == :sym
          [key.to_a[0], parse_node_to_type(value)]
        end.to_h

        Types::Record.new(keys_to_types)
      else
        parse_err "unable to parse type #{node_to_s(node).inspect}", node
      end
    end

    protected

    sig { params(msg: String, node: Parser::AST::Node).void }
    def warning(msg, node)
      return if $VERBOSE.nil?

      print Rainbow("Parlour warning: ").yellow.dark.bold
      print Rainbow("Type generalization: ").magenta.bright.bold
      puts msg
      print Rainbow("      └ at code: ").blue.bright.bold
      puts node_to_s(node)
    end

    sig { params(node: T.nilable(Parser::AST::Node)).returns(T::Array[Symbol]) }
    # Given a node representing a simple chain of constants (such as A or
    # A::B::C), converts that node into an array of the constant names which
    # are accessed. For example, A::B::C would become [:A, :B, :C].
    #
    # @param [Parser::AST::Node, nil] node The node to convert. This must
    #   consist only of nested (:const) nodes.
    # @return [Array<Symbol>] The chain of constant names.
    def constant_names(node)
      node ? constant_names(node.to_a[0]) + [node.to_a[1]] : []
    end

    sig { params(node: Parser::AST::Node).returns(T::Boolean) }
    # Given a node, returns a boolean indicating whether that node represents a
    # a call to "sig" with a block. No further semantic checking, such as
    # whether it preceeds a method call, is done.
    #
    # @param [Parser::AST::Node] node The node to check.
    # @return [Boolean] True if that node represents a "sig" call, false
    #   otherwise.
    def sig_node?(node)
      node.type == :block &&
        node.to_a[0].type == :send &&
        node.to_a[0].to_a[1] == :sig
    end

    sig { params(path: NodePath).returns(T::Boolean) }
    # Given a path, returns a boolean indicating whether the previous sibling
    # represents a call to "sig" with a block.
    #
    # @param [NodePath] path The path to the namespace definition.
    # @return [Boolean] True if that node represents a "sig" call, false
    #   otherwise.
    def previous_sibling_sig_node?(path)
      previous_sibling = path.sibling(-1)
      previous_node = previous_sibling.traverse(ast)
      sig_node?(previous_node)
    rescue IndexError, ArgumentError, TypeError
      # `sibling` call could raise IndexError or ArgumentError if reaching into negative indices
      # `traverse` call could raise TypeError if path doesn't return Parser::AST::Node

      false
    end

    sig { params(node: T.nilable(Parser::AST::Node)).returns(T.nilable(String)) }
    # Given an AST node, returns the source code from which it was constructed.
    # If the given AST node is nil, this returns nil.
    #
    # @param [Parser::AST::Node, nil] node The AST node, or nil.
    # @return [String] The source code string it represents, or nil.
    def node_to_s(node)
      return nil unless node

      exp = node.loc.expression
      exp.source_buffer.source[exp.begin_pos...exp.end_pos]
    end

    sig { params(node: T.nilable(Parser::AST::Node), modifier: Symbol).returns(T::Boolean) }
    # Given an AST node and a symbol, determines if that node is a call (or a
    # body containing a call at the top level) to the method represented by the
    # symbol, without any arguments or a block.
    #
    # This is designed to be used to determine if a namespace body uses a Sorbet
    # modifier such as "abstract!".
    #
    # @param [Parser::AST::Node, nil] node The AST node to search in.
    # @param [Symbol] modifier The method name to search for.
    # @return [T::Boolean] True if the call is found, or false otherwise.
    def body_has_modifier?(node, modifier)
      return false unless node

      (node.type == :send && node.to_a == [nil, modifier]) ||
        (node.type == :begin &&
          node.to_a.any? { |c| c.type == :send && c.to_a == [nil, modifier] })
    end

    sig { params(node: Parser::AST::Node).returns([T::Array[String], T::Array[String]]) }
    # Given an AST node representing the body of a class or module, returns two
    # arrays of the includes and extends contained within the body.
    #
    # @param [Parser::AST::Node] node The body of the namespace.
    # @return [(Array<String>, Array<String>)] An array of the includes and an
    #   array of the extends.
    def body_includes_and_extends(node)
      result = [[], []]

      nodes_to_search = node.type == :begin ? node.to_a : [node]
      nodes_to_search.each do |this_node|
        next unless this_node.type == :send
        target, name, *args = *this_node
        next unless target.nil? && args.length == 1

        if name == :include
          result[0] << node_to_s(args.first)
        elsif name == :extend
          result[1] << node_to_s(args.first)
        end
      end

      result
    end

    sig { params(desc: String, node: T.any(Parser::AST::Node, NodePath)).returns(T.noreturn) }
    # Raises a parse error on a node.
    # @param [String] desc A description of the error.
    # @param [Parser::AST::Node, NodePath] A node, passed as either a path or a
    #   raw parser node.
    def parse_err(desc, node)
      node = node.traverse(ast) if node.is_a?(NodePath)
      range = node.loc.expression
      buffer = range.source_buffer

      raise ParseError.new(buffer, range), desc
    end

    sig do
      type_parameters(:A, :B)
        .params(
          a: T::Array[T.type_parameter(:A)],
          fa: T.proc.params(item: T.type_parameter(:A)).returns(T.untyped),
          b: T::Array[T.type_parameter(:B)],
          fb: T.proc.params(item: T.type_parameter(:B)).returns(T.untyped)
        )
        .returns(T::Array[[T.type_parameter(:A), T.type_parameter(:B)]])
    end
    # Given two arrays and functions to get a key for each item in the two
    # arrays, joins the two arrays into one array of pairs by that key.
    #
    # The arrays should both be the same length, and the key functions should
    # never return duplicate keys for two different items.
    #
    # @param [Array<A>] a The first array.
    # @param [A -> Any] fa A function to obtain a key for any element in the
    #   first array.
    # @param [Array<B>] b The second array.
    # @param [B -> Any] fb A function to obtain a key for any element in the
    #   second array.
    # @return [Array<(A, B)>] An array of pairs, where the left of the pair is
    #   an element from A and the right is the element from B with the
    #   corresponding key.
    def zip_by(a, fa, b, fb)
      raise ArgumentError, "arrays are not the same length" if a.length != b.length

      a.map do |a_item|
        a_key = fa.(a_item)
        b_items = b.select { |b_item| fb.(b_item) == a_key }
        raise "multiple items for key #{a_key}" if b_items.length > 1
        raise "no item in second list corresponding to key #{a_key}" if b_items.length == 0

        [a_item, T.must(b_items[0])]
      end
    end
  end
end
