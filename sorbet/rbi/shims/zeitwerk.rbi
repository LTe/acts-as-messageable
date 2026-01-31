# typed: strict

class Zeitwerk::Loader
  sig { returns(T::Boolean) }
  def setup; end

  sig { params(warn_on_extra_files: T::Boolean).returns(Zeitwerk::Loader) }
  def self.for_gem(warn_on_extra_files: T.unsafe(nil)); end
end
