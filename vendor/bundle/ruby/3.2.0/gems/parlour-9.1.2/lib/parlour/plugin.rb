# typed: true
module Parlour
  # The base class for user-defined RBI generation plugins.
  #
  # This class is *abstract*.
  class Plugin
    extend T::Sig
    extend T::Helpers
    abstract!

    @@registered_plugins = {}

    sig { returns(T::Hash[String, T.class_of(Plugin)]) }
    # Returns all registered plugins, as a hash of their paths to the {Plugin}
    # instances themselves.
    #
    # @return [{String, Plugin}]
    def self.registered_plugins
      @@registered_plugins
    end

    sig { params(new_plugin: T.class_of(Plugin)).void }
    # Called automatically by the Ruby interpreter when {Plugin} is subclassed.
    # This registers the new subclass into {registered_plugins}.
    #
    # @param new_plugin [Plugin] The new plugin.
    # @return [void]
    def self.inherited(new_plugin)
      Debugging.debug_puts(self, 'Registered')
      registered_plugins[T.must(new_plugin.name)] = new_plugin
    end

    sig { params(plugins: T::Array[Plugin], generator: RbiGenerator, allow_failure: T::Boolean).void }
    # Runs an array of plugins on a given generator instance.
    #
    # @param plugins [Array<Plugin>] An array of {Plugin} instances.
    # @param generator [RbiGenerator] The {RbiGenerator} to run the plugins on.
    # @param allow_failure [Boolean] Whether to keep running plugins if a plugin
    #   throws an exception. If false, the exception is re-raised when caught.
    # @return [void]
    def self.run_plugins(plugins, generator, allow_failure: true)
      plugins.each do |plugin|
        begin
          puts "=== #{plugin.class.name}"
          generator.current_plugin = plugin
          plugin.generate(generator.root)
        rescue Exception => e
          raise e unless allow_failure
          puts "!!! This plugin threw an exception: #{e}"
        end
      end
    end

    sig { params(options: T::Hash[T.untyped, T.untyped]).void }
    def initialize(options); end

    sig { abstract.params(root: RbiGenerator::Namespace).void }
    # Plugin subclasses should redefine this method and do their RBI generation
    # inside it.
    #
    # This method is *abstract*.
    #
    # @param root [RbiGenerator::Namespace] The root {RbiGenerator::Namespace}.
    # @return [void]
    def generate(root); end

    sig { returns(T.nilable(String)) }
    # The strictness level which this plugin would prefer the generated RBI
    # uses. If other plugins request different strictness levels, then the 
    # lowest strictness will be used, meaning there is no guarantee that this
    # level will be used.
    attr_accessor :strictness
  end
end
