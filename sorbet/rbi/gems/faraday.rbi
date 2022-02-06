# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/faraday/all/faraday.rbi
#
# faraday-0.9.2

module Faraday
  def self.const_missing(name); end
  def self.default_adapter; end
  def self.default_adapter=(adapter); end
  def self.default_connection; end
  def self.default_connection=(arg0); end
  def self.default_connection_options; end
  def self.default_connection_options=(arg0); end
  def self.lib_path; end
  def self.lib_path=(arg0); end
  def self.method_missing(name, *args, &block); end
  def self.new(url = nil, options = nil); end
  def self.require_lib(*libs); end
  def self.require_libs(*libs); end
  def self.root_path; end
  def self.root_path=(arg0); end
end
module Faraday::Utils
  def URI(url); end
  def build_nested_query(value, prefix = nil, encoder = nil); end
  def build_query(params); end
  def deep_merge!(target, hash); end
  def deep_merge(source, hash); end
  def default_params_encoder; end
  def default_uri_parser; end
  def default_uri_parser=(parser); end
  def escape(s); end
  def normalize_params(params, name, v = nil); end
  def normalize_path(url); end
  def parse_nested_query(query); end
  def parse_query(query); end
  def self.default_params_encoder=(arg0); end
  def sort_query_params(query); end
  def unescape(s); end
  extend Faraday::Utils
end
class Faraday::Utils::Headers < Hash
  def [](k); end
  def []=(k, v); end
  def delete(k); end
  def fetch(k, *args, &block); end
  def has_key?(k); end
  def include?(k); end
  def initialize(hash = nil); end
  def initialize_copy(other); end
  def key?(k); end
  def member?(k); end
  def merge!(other); end
  def merge(other); end
  def names; end
  def parse(header_string); end
  def replace(other); end
  def self.from(value); end
  def to_hash; end
  def update(other); end
end
class Faraday::Utils::ParamsHash < Hash
  def [](key); end
  def []=(key, value); end
  def convert_key(key); end
  def delete(key); end
  def has_key?(key); end
  def include?(key); end
  def key?(key); end
  def member?(key); end
  def merge!(params); end
  def merge(params); end
  def merge_query(query, encoder = nil); end
  def replace(other); end
  def to_query(encoder = nil); end
  def update(params); end
end
class Faraday::Options < Struct
  def [](key); end
  def clear; end
  def delete(key); end
  def each; end
  def each_key; end
  def each_value; end
  def empty?; end
  def fetch(key, *args); end
  def has_key?(key); end
  def has_value?(value); end
  def inspect; end
  def key?(key); end
  def keys; end
  def merge!(obj); end
  def merge(value); end
  def self.attribute_options; end
  def self.fetch_error_class; end
  def self.from(value); end
  def self.inherited(subclass); end
  def self.memoized(key); end
  def self.memoized_attributes; end
  def self.options(mapping); end
  def self.options_for(key); end
  def symbolized_key_set; end
  def to_hash; end
  def update(obj); end
  def value?(value); end
  def values_at(*keys); end
end
class Anonymous_Faraday_Options_14 < Faraday::Options
  def bind; end
  def bind=(_); end
  def boundary; end
  def boundary=(_); end
  def oauth; end
  def oauth=(_); end
  def open_timeout; end
  def open_timeout=(_); end
  def params_encoder; end
  def params_encoder=(_); end
  def proxy; end
  def proxy=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def timeout; end
  def timeout=(_); end
end
class Faraday::RequestOptions < Anonymous_Faraday_Options_14
  def []=(key, value); end
end
class Anonymous_Faraday_Options_15 < Faraday::Options
  def ca_file; end
  def ca_file=(_); end
  def ca_path; end
  def ca_path=(_); end
  def cert_store; end
  def cert_store=(_); end
  def certificate; end
  def certificate=(_); end
  def client_cert; end
  def client_cert=(_); end
  def client_key; end
  def client_key=(_); end
  def private_key; end
  def private_key=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def verify; end
  def verify=(_); end
  def verify_depth; end
  def verify_depth=(_); end
  def verify_mode; end
  def verify_mode=(_); end
  def version; end
  def version=(_); end
end
class Faraday::SSLOptions < Anonymous_Faraday_Options_15
  def disable?; end
  def verify?; end
end
class Anonymous_Faraday_Options_16 < Faraday::Options
  def password; end
  def password=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def uri; end
  def uri=(_); end
  def user; end
  def user=(_); end
end
class Faraday::ProxyOptions < Anonymous_Faraday_Options_16
  def host(*args, &block); end
  def host=(*args, &block); end
  def password; end
  def path(*args, &block); end
  def path=(*args, &block); end
  def port(*args, &block); end
  def port=(*args, &block); end
  def scheme(*args, &block); end
  def scheme=(*args, &block); end
  def self.from(value); end
  def user; end
  extend Forwardable
end
class Anonymous_Faraday_Options_17 < Faraday::Options
  def builder; end
  def builder=(_); end
  def builder_class; end
  def builder_class=(_); end
  def headers; end
  def headers=(_); end
  def parallel_manager; end
  def parallel_manager=(_); end
  def params; end
  def params=(_); end
  def proxy; end
  def proxy=(_); end
  def request; end
  def request=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def ssl; end
  def ssl=(_); end
  def url; end
  def url=(_); end
end
class Faraday::ConnectionOptions < Anonymous_Faraday_Options_17
  def builder_class; end
  def new_builder(block); end
  def request; end
  def ssl; end
end
class Anonymous_Faraday_Options_18 < Faraday::Options
  def body; end
  def body=(_); end
  def method; end
  def method=(_); end
  def parallel_manager; end
  def parallel_manager=(_); end
  def params; end
  def params=(_); end
  def request; end
  def request=(_); end
  def request_headers; end
  def request_headers=(_); end
  def response; end
  def response=(_); end
  def response_headers; end
  def response_headers=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def ssl; end
  def ssl=(_); end
  def status; end
  def status=(_); end
  def url; end
  def url=(_); end
end
class Faraday::Env < Anonymous_Faraday_Options_18
  def [](key); end
  def []=(key, value); end
  def clear_body; end
  def custom_members; end
  def in_member_set?(key); end
  def inspect; end
  def needs_body?; end
  def parallel?; end
  def params_encoder(*args, &block); end
  def parse_body?; end
  def self.from(value); end
  def self.member_set; end
  def success?; end
  extend Forwardable
end
class Faraday::Connection
  def adapter(*args, &block); end
  def app(*args, &block); end
  def authorization(type, token); end
  def basic_auth(login, pass); end
  def build(*args, &block); end
  def build_exclusive_url(url = nil, params = nil, params_encoder = nil); end
  def build_request(method); end
  def build_url(url = nil, extra_params = nil); end
  def builder; end
  def default_parallel_manager; end
  def default_parallel_manager=(arg0); end
  def delete(url = nil, params = nil, headers = nil); end
  def dup; end
  def get(url = nil, params = nil, headers = nil); end
  def head(url = nil, params = nil, headers = nil); end
  def headers; end
  def headers=(hash); end
  def host(*args, &block); end
  def host=(*args, &block); end
  def in_parallel(manager = nil); end
  def in_parallel?; end
  def initialize(url = nil, options = nil); end
  def options; end
  def parallel_manager; end
  def params; end
  def params=(hash); end
  def patch(url = nil, body = nil, headers = nil, &block); end
  def path_prefix(*args, &block); end
  def path_prefix=(value); end
  def port(*args, &block); end
  def port=(*args, &block); end
  def post(url = nil, body = nil, headers = nil, &block); end
  def proxy(arg = nil); end
  def put(url = nil, body = nil, headers = nil, &block); end
  def request(*args, &block); end
  def response(*args, &block); end
  def run_request(method, url, body, headers); end
  def scheme(*args, &block); end
  def scheme=(*args, &block); end
  def set_authorization_header(header_type, *args); end
  def ssl; end
  def token_auth(token, options = nil); end
  def url_prefix; end
  def url_prefix=(url, encoder = nil); end
  def use(*args, &block); end
  def with_uri_credentials(uri); end
  extend Forwardable
end
class Faraday::RackBuilder
  def ==(other); end
  def [](idx); end
  def adapter(key, *args, &block); end
  def app; end
  def assert_index(index); end
  def build(options = nil); end
  def build_env(connection, request); end
  def build_response(connection, request); end
  def delete(handler); end
  def dup; end
  def handlers; end
  def handlers=(arg0); end
  def initialize(handlers = nil); end
  def insert(index, *args, &block); end
  def insert_after(index, *args, &block); end
  def insert_before(index, *args, &block); end
  def lock!; end
  def locked?; end
  def raise_if_locked; end
  def request(key, *args, &block); end
  def response(key, *args, &block); end
  def swap(index, *args, &block); end
  def to_app(inner_app); end
  def use(klass, *args, &block); end
  def use_symbol(mod, key, *args, &block); end
end
class Faraday::RackBuilder::StackLocked < RuntimeError
end
class Faraday::RackBuilder::Handler
  def ==(other); end
  def build(app); end
  def initialize(klass, *args, &block); end
  def inspect; end
  def klass; end
  def name; end
end
module Faraday::NestedParamsEncoder
  def self.decode(query); end
  def self.dehash(hash, depth); end
  def self.encode(params); end
  def self.escape(*args, &block); end
  def self.unescape(*args, &block); end
end
module Faraday::FlatParamsEncoder
  def self.decode(query); end
  def self.encode(params); end
  def self.escape(*args, &block); end
  def self.unescape(*args, &block); end
end
class Faraday::Middleware
  def initialize(app = nil); end
  def self.dependency(lib = nil); end
  def self.inherited(subclass); end
  def self.load_error; end
  def self.load_error=(arg0); end
  def self.loaded?; end
  def self.new(*arg0); end
  extend Faraday::MiddlewareRegistry
end
class Faraday::Adapter < Faraday::Middleware
  def call(env); end
  def save_response(env, status, body, headers = nil); end
  extend Faraday::Adapter::Parallelism
  extend Faraday::AutoloadHelper
end
module Faraday::Adapter::Parallelism
  def inherited(subclass); end
  def supports_parallel=(arg0); end
  def supports_parallel?; end
end
class Anonymous_Struct_19 < Struct
  def body; end
  def body=(_); end
  def headers; end
  def headers=(_); end
  def method; end
  def method=(_); end
  def options; end
  def options=(_); end
  def params; end
  def params=(_); end
  def path; end
  def path=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
end
class Faraday::Request < Anonymous_Struct_19
  def [](key); end
  def []=(key, value); end
  def headers=(hash); end
  def params=(hash); end
  def self.create(request_method); end
  def to_env(connection); end
  def url(path, params = nil); end
  extend Faraday::AutoloadHelper
  extend Faraday::MiddlewareRegistry
end
class Faraday::Response
  def [](*args, &block); end
  def apply_request(request_env); end
  def body; end
  def env; end
  def finish(env); end
  def finished?; end
  def headers; end
  def initialize(env = nil); end
  def marshal_dump; end
  def marshal_load(env); end
  def on_complete; end
  def status; end
  def success?; end
  def to_hash(*args, &block); end
  extend Faraday::AutoloadHelper
  extend Faraday::MiddlewareRegistry
  extend Forwardable
end
class Faraday::Response::Middleware < Faraday::Middleware
  def call(env); end
  def on_complete(env); end
end
class Faraday::CompositeReadIO
  def advance_io; end
  def close; end
  def current_io; end
  def ensure_open_and_readable; end
  def initialize(*parts); end
  def length; end
  def read(length = nil, outbuf = nil); end
  def rewind; end
end
class Faraday::Error < StandardError
end
class Faraday::MissingDependency < Faraday::Error
end
class Faraday::ClientError < Faraday::Error
  def backtrace; end
  def initialize(ex, response = nil); end
  def inspect; end
  def response; end
end
class Faraday::ConnectionFailed < Faraday::ClientError
end
class Faraday::ResourceNotFound < Faraday::ClientError
end
class Faraday::ParsingError < Faraday::ClientError
end
class Faraday::TimeoutError < Faraday::ClientError
  def initialize(ex = nil); end
end
class Faraday::SSLError < Faraday::ClientError
end
module Faraday::AutoloadHelper
  def all_loaded_constants; end
  def autoload_all(prefix, options); end
  def load_autoloaded_constants; end
end
module Faraday::MiddlewareRegistry
  def fetch_middleware(key); end
  def load_middleware(key); end
  def lookup_middleware(key); end
  def middleware_mutex(&block); end
  def register_middleware(autoload_path = nil, mapping = nil); end
end
class Object < BasicObject
end
