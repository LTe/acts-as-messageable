require_relative 'polyfill/version'
require_relative 'polyfill/internal_utils'

module Polyfill
  module Module; end

  def get(module_name, methods, options = {})
    if Object.const_get(module_name.to_s, false).is_a?(Class)
      raise ArgumentError, "#{module_name} is a class not a module"
    end

    version_option = options.delete(:version)

    #
    # parse options
    #
    versions = InternalUtils.polyfill_versions_to_use(version_option)

    unless options.empty?
      raise ArgumentError, "unknown keyword: #{options.first[0]}"
    end

    #
    # find all polyfills for the module across all versions
    #
    modules_with_updates, modules = InternalUtils.modules_to_use(module_name, versions)

    #
    # remove methods that were not requested
    #
    requested_methods = InternalUtils.methods_to_keep(modules_with_updates, methods, '#', module_name)

    modules.each do |instance_module|
      InternalUtils.keep_only_these_methods!(instance_module, requested_methods)
    end

    #
    # build the module to return
    #
    InternalUtils.create_module(module_name, methods, options, version_option) do |mod|
      # make sure the methods get added if this module is included
      mod.singleton_class.send(:define_method, :included) do |base|
        modules.each do |module_to_add|
          base.include module_to_add unless module_to_add.instance_methods.empty?
        end
      end

      # make sure the methods get added if this module is extended
      mod.singleton_class.send(:define_method, :extended) do |base|
        modules.each do |module_to_add|
          base.extend module_to_add unless module_to_add.instance_methods.empty?
        end
      end

      # make sure the methods get added if this module is prepended
      mod.singleton_class.send(:define_method, :prepended) do |base|
        modules.each do |module_to_add|
          base.prepend module_to_add unless module_to_add.instance_methods.empty?
        end
      end
    end
  end
  module_function :get
end

def Polyfill(options = {}) # rubocop:disable Naming/MethodName
  #
  # parse options
  #
  objects, others = options.partition { |key,| key[/\A[A-Z]/] }
  objects.sort! do |a, b|
    if !a.is_a?(Class) && b.is_a?(Class)
      -1
    elsif a.is_a?(Class) && !b.is_a?(Class)
      1
    else
      0
    end
  end
  objects.each do |object_name, _|
    Object.const_get(object_name.to_s, false)
  end
  others = others.to_h

  versions = Polyfill::InternalUtils.polyfill_versions_to_use(others.delete(:version))
  native = others.delete(:native) { false }

  unless others.empty?
    raise ArgumentError, "unknown keyword: #{others.first[0]}"
  end

  #
  # build the module to return
  #
  Polyfill::InternalUtils.create_module(options) do |mod|
    objects.each do |object_name, methods|
      #
      # find all polyfills for the object across all versions
      #
      modules_with_updates, instance_modules = Polyfill::InternalUtils.modules_to_use(object_name, versions)

      class_modules_with_updates = modules_with_updates.map do |module_with_updates|
        begin
          module_with_updates.const_get(:ClassMethods, false)
        rescue NameError
          nil
        end
      end.compact
      class_modules = instance_modules.map do |module_with_updates|
        begin
          module_with_updates.const_get(:ClassMethods, false).clone
        rescue NameError
          nil
        end
      end.compact

      #
      # get all requested class and instance methods
      #
      if methods != :all && (method_name = methods.find { |method| method !~ /\A[.#]/ })
        raise ArgumentError, %Q("#{method_name}" must start with a "." if it's a class method or "#" if it's an instance method)
      end

      instance_methods, class_methods =
        if methods == :all
          %i[all all]
        else
          methods
            .partition { |m| m.start_with?('#') }
            .map { |method_list| method_list.map { |name| name[1..-1].to_sym } }
        end

      requested_instance_methods =
        Polyfill::InternalUtils.methods_to_keep(modules_with_updates, instance_methods, '#', object_name)
      requested_class_methods =
        Polyfill::InternalUtils.methods_to_keep(class_modules_with_updates, class_methods, '.', object_name)

      #
      # get the class(es) to refine
      #
      base_object = object_name.to_s
      base_objects =
        case base_object
        when 'Comparable'
          %w[Numeric String Time]
        when 'Enumerable'
          %w[Array Dir Enumerator Hash IO Matrix Range StringIO Struct Vector]
        when 'Kernel'
          %w[Object]
        else
          [base_object]
        end
      base_objects.select! do |klass|
        begin
          Object.const_get(klass, false)
        rescue NameError
          false
        end
      end

      #
      # refine in class methods
      #
      class_modules.each do |class_module|
        Polyfill::InternalUtils.keep_only_these_methods!(class_module, requested_class_methods)

        next if class_module.instance_methods.empty?

        mod.module_exec(requested_class_methods) do |methods_added|
          base_objects.each do |klass|
            refine Object.const_get(klass, false).singleton_class do
              include class_module

              if native
                Polyfill::InternalUtils.ignore_warnings do
                  define_method :respond_to? do |name, include_all = false|
                    return true if methods_added.include?(name)

                    super(name, include_all)
                  end

                  define_method :__send__ do |name, *args, &block|
                    return super(name, *args, &block) unless methods_added.include?(name)

                    class_module.instance_method(name).bind(self).call(*args, &block)
                  end
                  alias_method :send, :__send__
                end
              end
            end
          end
        end
      end

      #
      # refine in instance methods
      #
      instance_modules.each do |instance_module|
        Polyfill::InternalUtils.keep_only_these_methods!(instance_module, requested_instance_methods)

        next if instance_module.instance_methods.empty?

        mod.module_exec(requested_instance_methods) do |methods_added|
          base_objects.each do |klass|
            refine Object.const_get(klass, false) do
              include instance_module

              # Certain Kernel methods are private outside of Kernel
              if klass == 'Object'
                %i[Complex Float Integer Rational].each do |method|
                  private method if methods_added.include?(method)
                end
              end

              if native
                Polyfill::InternalUtils.ignore_warnings do
                  define_method :respond_to? do |name, include_all = false|
                    return super(name, include_all) unless methods_added.include?(name)

                    true
                  end

                  define_method :__send__ do |name, *args, &block|
                    return super(name, *args, &block) unless methods_added.include?(name)

                    instance_module.instance_method(name).bind(self).call(*args, &block)
                  end
                  alias_method :send, :__send__
                end
              end
            end
          end
        end
      end
    end
  end
end

require_relative 'polyfill/v2_2'
require_relative 'polyfill/v2_3'
require_relative 'polyfill/v2_4'
require_relative 'polyfill/v2_5'
require_relative 'polyfill/v2_6'
