# typed: true

module Parlour
  class DetachedRbiGenerator < RbiGenerator
    sig { returns(T.untyped) }
    def detached!
      raise "cannot call methods on a detached RBI generator"
    end

    sig { override.returns(Options) }
    def options
      detached!
    end

    sig { override.returns(T.nilable(Plugin)) }
    def current_plugin
      nil
    end

    sig { override.params(strictness: String).returns(String) }
    def rbi(strictness = 'strong')
      detached!
    end
  end
end