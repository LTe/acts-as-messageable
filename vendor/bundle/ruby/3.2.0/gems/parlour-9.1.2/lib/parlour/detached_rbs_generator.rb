# typed: true

module Parlour
  class DetachedRbsGenerator < RbsGenerator
    sig { returns(T.untyped) }
    def detached!
      raise "cannot call methods on a detached RBS generator"
    end

    sig { override.returns(Options) }
    def options
      detached!
    end

    sig { override.returns(T.nilable(Plugin)) }
    def current_plugin
      nil
    end

    sig { override.returns(String) }
    def rbs
      detached!
    end
  end
end