module Polyfill
  module InternalUtils # rubocop:disable Metrics/ModuleLength
    VERSIONS = {
      '2.2' => 'V2_2',
      '2.3' => 'V2_3',
      '2.4' => 'V2_4',
      '2.5' => 'V2_5',
      '2.6' => 'V2_6'
    }.freeze
    private_constant :VERSIONS

    def current_ruby_version
      @current_ruby_version ||= RUBY_VERSION[/\A(\d+\.\d+)/, 1]
    end
    module_function :current_ruby_version

    def ignore_warnings
      orig = $VERBOSE
      $VERBOSE = nil

      yield

      $VERBOSE = orig
    end
    module_function :ignore_warnings

    def polyfill_versions_to_use(desired_version = nil)
      desired_version = VERSIONS.keys.max if desired_version.nil?

      unless VERSIONS.key?(desired_version)
        raise ArgumentError, "invalid value for keyword version: #{desired_version}"
      end

      VERSIONS
        .reject { |version, _| version > desired_version }
        .map { |version, mod| [version, Polyfill.const_get(mod, false)] }
        .to_h
    end
    module_function :polyfill_versions_to_use

    def keep_only_these_methods!(mod, whitelist)
      mod.instance_methods.each do |name|
        mod.send(:remove_method, name) unless whitelist.include?(name)
      end
    end
    module_function :keep_only_these_methods!

    def modules_to_use(module_name, versions)
      modules_with_updates = []
      modules = []

      versions.each do |version_number, version_module|
        begin
          final_module = version_module.const_get(module_name.to_s, false)

          modules_with_updates << final_module

          next if version_number <= InternalUtils.current_ruby_version

          modules << final_module.clone
        rescue NameError
          nil
        end
      end

      if modules_with_updates.empty?
        raise ArgumentError, %Q("#{module_name}" has no updates)
      end

      [modules_with_updates, modules]
    end
    module_function :modules_to_use

    def methods_to_keep(modules, methods, lead_symbol, module_name)
      methods_with_updates = modules.flat_map(&:instance_methods).uniq
      requested_methods = methods == :all ? methods_with_updates : methods

      unless (leftovers = (requested_methods - methods_with_updates)).empty?
        raise ArgumentError, %Q("#{lead_symbol}#{leftovers.first}" is not a valid method on #{module_name} or has no updates)
      end

      requested_methods
    end
    module_function :methods_to_keep

    def create_module(*args)
      module_name = namify_arguments(*args)

      if ::Polyfill::Module.const_defined?(module_name, false)
        ::Polyfill::Module.const_get(module_name, false)
      else
        mod = ::Module.new
        yield(mod)
        ::Polyfill::Module.const_set(module_name, mod)
      end
    end
    module_function :create_module

    def namify_arguments(*args)
      string = args.map(&:inspect).join
      # we don't need this to be decodable,
      # we just need a consistent class-nameable output for a consistent arbitrary input
      # safest module name is: start with capital then, A-Za-z0-9_
      encoded = [string].pack('m0')
        .gsub(%r{[+/=]}, '+' => '_1', '/' => '_2', '=' => '_')
      "M#{encoded}"
    end
    module_function :namify_arguments

    def to_str(obj)
      begin
        unless obj.respond_to?(:to_str)
          raise TypeError, "no implicit conversion of #{obj.class} into String"
        end
      rescue NoMethodError
        raise TypeError, 'no implicit conversion of BasicObject into String'
      end

      obj.to_str
    end
    module_function :to_str

    def to_int(obj)
      begin
        unless obj.respond_to?(:to_int)
          raise TypeError, "no implicit conversion of #{obj.class} into Integer"
        end
      rescue NoMethodError
        raise TypeError, 'no implicit conversion of BasicObject into Integer'
      end

      obj.to_int
    end
    module_function :to_int

    def to_f(obj)
      begin
        unless obj.respond_to?(:to_f)
          raise TypeError, "no implicit conversion of #{obj.class} into Float"
        end
      rescue NoMethodError
        raise TypeError, 'no implicit conversion of BasicObject into Float'
      end

      obj.to_f
    end
    module_function :to_f

    def to_hash(obj)
      begin
        unless obj.respond_to?(:to_hash)
          raise TypeError, "no implicit conversion of #{obj.class} into Hash"
        end
      rescue NoMethodError
        raise TypeError, 'no implicit conversion of BasicObject into Hash'
      end

      obj.to_hash
    end
    module_function :to_hash
  end
end
