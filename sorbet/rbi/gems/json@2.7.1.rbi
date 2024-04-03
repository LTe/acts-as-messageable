# typed: false

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `json` gem.
# Please instead update this file by running `bin/tapioca gem json`.

class Class < ::Module
  def json_creatable?; end
end

module JSON
  private

  def dump(obj, anIO = T.unsafe(nil), limit = T.unsafe(nil), kwargs = T.unsafe(nil)); end
  def fast_generate(obj, opts = T.unsafe(nil)); end
  def fast_unparse(obj, opts = T.unsafe(nil)); end
  def generate(obj, opts = T.unsafe(nil)); end
  def load(source, proc = T.unsafe(nil), options = T.unsafe(nil)); end
  def load_file(filespec, opts = T.unsafe(nil)); end
  def load_file!(filespec, opts = T.unsafe(nil)); end
  def merge_dump_options(opts, strict: T.unsafe(nil)); end
  def parse(source, opts = T.unsafe(nil)); end
  def parse!(source, opts = T.unsafe(nil)); end
  def pretty_generate(obj, opts = T.unsafe(nil)); end
  def pretty_unparse(obj, opts = T.unsafe(nil)); end
  def recurse_proc(result, &proc); end
  def restore(source, proc = T.unsafe(nil), options = T.unsafe(nil)); end
  def unparse(obj, opts = T.unsafe(nil)); end

  class << self
    def [](object, opts = T.unsafe(nil)); end
    def create_fast_state; end
    def create_id; end
    def create_id=(new_value); end
    def create_pretty_state; end
    def deep_const_get(path); end
    def dump(obj, anIO = T.unsafe(nil), limit = T.unsafe(nil), kwargs = T.unsafe(nil)); end
    def dump_default_options; end
    def dump_default_options=(_arg0); end
    def fast_generate(obj, opts = T.unsafe(nil)); end
    def fast_unparse(obj, opts = T.unsafe(nil)); end
    def generate(obj, opts = T.unsafe(nil)); end
    def generator; end
    def generator=(generator); end
    def iconv(to, from, string); end
    def load(source, proc = T.unsafe(nil), options = T.unsafe(nil)); end
    def load_default_options; end
    def load_default_options=(_arg0); end
    def load_file(filespec, opts = T.unsafe(nil)); end
    def load_file!(filespec, opts = T.unsafe(nil)); end
    def parse(source, opts = T.unsafe(nil)); end
    def parse!(source, opts = T.unsafe(nil)); end
    def parser; end
    def parser=(parser); end
    def pretty_generate(obj, opts = T.unsafe(nil)); end
    def pretty_unparse(obj, opts = T.unsafe(nil)); end
    def recurse_proc(result, &proc); end
    def restore(source, proc = T.unsafe(nil), options = T.unsafe(nil)); end
    def state; end
    def state=(_arg0); end
    def unparse(obj, opts = T.unsafe(nil)); end

    private

    def merge_dump_options(opts, strict: T.unsafe(nil)); end
  end
end

JSON::CREATE_ID_TLS_KEY = T.let(T.unsafe(nil), String)
JSON::DEFAULT_CREATE_ID = T.let(T.unsafe(nil), String)

class JSON::GenericObject < ::OpenStruct
  def as_json(*_arg0); end
  def to_hash; end
  def to_json(*a); end
  def |(other); end

  class << self
    def dump(obj, *args); end
    def from_hash(object); end
    def json_creatable=(_arg0); end
    def json_creatable?; end
    def json_create(data); end
    def load(source, proc = T.unsafe(nil), opts = T.unsafe(nil)); end
  end
end

class JSON::JSONError < ::StandardError
  class << self
    def wrap(exception); end
  end
end

JSON::NOT_SET = T.let(T.unsafe(nil), Object)
JSON::Parser = JSON::Ext::Parser
JSON::State = JSON::Ext::Generator::State
JSON::UnparserError = JSON::GeneratorError

module Kernel
  private

  def JSON(object, *args); end
  def j(*objs); end
  def jj(*objs); end
end
