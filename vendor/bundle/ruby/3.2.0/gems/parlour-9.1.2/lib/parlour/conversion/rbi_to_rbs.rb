# typed: true
module Parlour
  module Conversion
    # Converts RBI types to RBS types.
    class RbiToRbs < Converter
      extend T::Sig

      sig { params(rbs_gen: RbsGenerator).void }
      def initialize(rbs_gen)
        super()
        @rbs_gen = rbs_gen
      end

      sig { returns(RbsGenerator) }
      attr_reader :rbs_gen

      sig { params(from: RbiGenerator::Namespace, to: RbsGenerator::Namespace).void }
      def convert_all(from, to)
        from.children.each do |child|
          convert_object(child, to)
        end        
      end

      sig do
        params(
          node: RbiGenerator::RbiObject,
          new_parent: RbsGenerator::Namespace,
        ).void
      end
      def convert_object(node, new_parent)        
        case node
        when RbiGenerator::StructClassNamespace
          add_warning 'performing a one-way conversion of an RBI struct to RBS', node

          klass = new_parent.create_class(node.name)
          klass.add_comments(node.comments)

          # Create a constructor
          klass.create_method('initialize', [
            RbsGenerator::MethodSignature.new(
              node.props.map do |prop|
                RbsGenerator::Parameter.new(
                  "#{prop.name}:",
                  type: prop.type,
                  required: !prop.optional,
                )
              end,
              nil,
            )
          ])

          # Make each prop a getter (and setter, if not immutable) attribute
          node.props.each do |prop|
            klass.create_attribute(
              prop.name,
              kind: prop.immutable ? :reader : :accessor,
              type: prop.type,
            )
          end

          klass 

        when RbiGenerator::EnumClassNamespace
          add_warning 'performing a one-way conversion of an RBI enum to RBS', node

          klass = new_parent.create_class(node.name)
          klass.add_comments(node.comments)

          # Define .values
          klass.create_method('values', [
            RbsGenerator::MethodSignature.new([], Types::Array.new(node.name))
          ], class_method: true)

          # Define each enum variant
          node.enums.each do |variant|
            # We don't care about any extra value
            variant = variant[0] if Array === variant

            klass.create_constant(variant, type: node.name)
          end

          klass

        when RbiGenerator::Arbitrary
          add_warning 'converting type of Arbitrary is likely to cause syntax errors; doing it anyway', node
          new_parent.create_arbitrary(
            code: node.code,
          ).add_comments(node.comments)

        when RbiGenerator::Attribute
          if node.class_attribute
            add_warning 'RBS does not support class attributes; dropping', node
            return
          end
          new_parent.create_attribute(
            node.name,
            kind: node.kind,
            type: node.type,
          ).add_comments(node.comments)

        when RbiGenerator::ClassNamespace
          if node.abstract
            add_warning 'RBS does not support abstract classes', node
          end
          klass = new_parent.create_class(
            node.name,
            superclass: node.superclass
          )
          klass.add_comments(node.comments)
          node.children.each do |child|
            convert_object(child, klass)
          end

        when RbiGenerator::Constant
          if node.eigen_constant
            add_warning 'RBS does not support constants on eigenclasses; dropping', node
            return
          end
          new_parent.create_constant(
            node.name,
            type: node.value,
          ).add_comments(node.comments)

        when RbiGenerator::TypeAlias
          new_parent.create_type_alias(
            node.name,
            type: node.type,
          ).add_comments(node.comments)

        when RbiGenerator::Extend
          new_parent.create_extend(node.name).add_comments(node.comments)

        when RbiGenerator::Include
          new_parent.create_include(node.name).add_comments(node.comments)

        when RbiGenerator::Method
          # Convert parameters
          parameters = node.parameters
            .reject { |param| param.kind == :block }
            .map do |param|
              RbsGenerator::Parameter.new(
                param.name,
                type: param.type,
                required: param.default.nil?
              )
            end

          # Find block if there is one
          block_param = node.parameters.find { |param| param.kind == :block }
          if block_param
            if String === block_param.type
              add_warning "block must have a Types::Type for conversion; dropping block", node
              block = nil
            else
              # A nilable proc is an optional block
              block_param_type = block_param.type
              if Types::Nilable === block_param_type && Types::Proc === block_param_type.type
                t = T.cast(block_param_type.type, Types::Proc)
                required = false
                block = RbsGenerator::Block.new(t, required)
              elsif Types::Proc === block_param_type
                t = block_param_type
                required = true
                block = RbsGenerator::Block.new(t, required)
              elsif Types::Untyped === block_param_type
                # Consider there to be a block of unknown types
                block = RbsGenerator::Block.new(
                  Types::Proc.new(
                    [
                      Types::Proc::Parameter.new('*args', Types::Untyped.new),
                      Types::Proc::Parameter.new('**kwargs', Types::Untyped.new),
                    ],
                    Types::Untyped.new,
                  ),
                  false,
                )
              else
                add_warning 'block type must be a Types::Proc (or nilable one); dropping block', node
              end
            end
          else
            block = nil
          end

          new_parent.create_method(
            node.name,
            [
              RbsGenerator::MethodSignature.new(
                parameters,
                node.return_type,
                block: block,
                type_parameters: node.type_parameters,
              )
            ],
            class_method: node.class_method,
          ).add_comments(node.comments)

        when RbiGenerator::ModuleNamespace
          if node.interface
            rbs_node = new_parent.create_interface(
              node.name,
            )
          else
            rbs_node = new_parent.create_module(
              node.name,
            )
          end
          rbs_node.add_comments(node.comments)
          node.children.each do |child|
            convert_object(child, rbs_node)
          end

        when RbiGenerator::Namespace
          add_warning 'unspecialized namespaces are not supposed to be in the tree; you may run into issues', node
          namespace = RbsGenerator::Namespace.new(rbs_gen)
          namespace.add_comments(node.comments)
          node.children.each do |child|
            convert_object(child, namespace)
          end
          new_parent.children << namespace

        else
          raise "missing conversion for #{node.describe}"
          # TODO: stick a T.absurd here
        end
      end
    end
  end
end