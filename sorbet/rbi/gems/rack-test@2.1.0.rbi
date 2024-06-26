# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rack-test` gem.
# Please instead update this file by running `bin/tapioca gem rack-test`.

module Rack
  class << self
    def release; end
    def version; end
  end
end

Rack::MockSession = Rack::Test::Session

module Rack::Test
  class << self
    def encoding_aware_strings?; end
  end
end

class Rack::Test::Cookie
  include ::Rack::Utils

  def initialize(raw, uri = T.unsafe(nil), default_host = T.unsafe(nil)); end

  def <=>(other); end
  def domain; end
  def empty?; end
  def expired?; end
  def expires; end
  def http_only?; end
  def matches?(uri); end
  def name; end
  def path; end
  def raw; end
  def replaces?(other); end
  def secure?; end
  def to_h; end
  def to_hash; end
  def valid?(uri); end
  def value; end

  private

  def default_uri; end
end

class Rack::Test::CookieJar
  def initialize(cookies = T.unsafe(nil), default_host = T.unsafe(nil)); end

  def <<(new_cookie); end
  def [](name); end
  def []=(name, value); end
  def delete(name); end
  def for(uri); end
  def get_cookie(name); end
  def merge(raw_cookies, uri = T.unsafe(nil)); end
  def to_hash; end

  private

  def each_cookie_for(uri); end
  def initialize_copy(other); end
end

Rack::Test::CookieJar::DELIMITER = T.let(T.unsafe(nil), String)
Rack::Test::DEFAULT_HOST = T.let(T.unsafe(nil), String)
Rack::Test::END_BOUNDARY = T.let(T.unsafe(nil), String)
class Rack::Test::Error < ::StandardError; end
Rack::Test::MULTIPART_BOUNDARY = T.let(T.unsafe(nil), String)

module Rack::Test::Methods
  extend ::Forwardable

  def _rack_test_current_session=(_arg0); end
  def authorize(*args, **_arg1, &block); end
  def basic_authorize(*args, **_arg1, &block); end
  def build_rack_test_session(_name); end
  def clear_cookies(*args, **_arg1, &block); end
  def current_session; end
  def custom_request(*args, **_arg1, &block); end
  def delete(*args, **_arg1, &block); end
  def env(*args, **_arg1, &block); end
  def follow_redirect!(*args, **_arg1, &block); end
  def get(*args, **_arg1, &block); end
  def head(*args, **_arg1, &block); end
  def header(*args, **_arg1, &block); end
  def last_request(*args, **_arg1, &block); end
  def last_response(*args, **_arg1, &block); end
  def options(*args, **_arg1, &block); end
  def patch(*args, **_arg1, &block); end
  def post(*args, **_arg1, &block); end
  def put(*args, **_arg1, &block); end
  def rack_mock_session(name = T.unsafe(nil)); end
  def rack_test_session(name = T.unsafe(nil)); end
  def request(*args, **_arg1, &block); end
  def set_cookie(*args, **_arg1, &block); end
  def with_session(name); end

  private

  def _rack_test_current_session; end
end

Rack::Test::START_BOUNDARY = T.let(T.unsafe(nil), String)

class Rack::Test::Session
  include ::Rack::Utils
  include ::Rack::Test::Utils
  extend ::Forwardable

  def initialize(app, default_host = T.unsafe(nil)); end

  def after_request(&block); end
  def authorize(username, password); end
  def basic_authorize(username, password); end
  def clear_cookies; end
  def cookie_jar; end
  def cookie_jar=(_arg0); end
  def custom_request(verb, uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end
  def default_host; end
  def delete(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end
  def env(name, value); end
  def follow_redirect!; end
  def get(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end
  def head(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end
  def header(name, value); end
  def last_request; end
  def last_response; end
  def options(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end
  def patch(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end
  def post(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end
  def put(uri, params = T.unsafe(nil), env = T.unsafe(nil), &block); end
  def request(uri, env = T.unsafe(nil), &block); end
  def restore_state; end
  def set_cookie(cookie, uri = T.unsafe(nil)); end

  private

  def append_query_params(query_array, query_params); end
  def close_body(body); end
  def env_for(uri, env); end
  def multipart_content_type(env); end
  def parse_uri(path, env); end
  def process_request(uri, env); end

  class << self
    def new(app, default_host = T.unsafe(nil)); end
  end
end

Rack::Test::Session::DEFAULT_ENV = T.let(T.unsafe(nil), Hash)

class Rack::Test::UploadedFile
  def initialize(content, content_type = T.unsafe(nil), binary = T.unsafe(nil), original_filename: T.unsafe(nil)); end

  def append_to(buffer); end
  def content_type; end
  def content_type=(_arg0); end
  def local_path; end
  def method_missing(method_name, *args, &block); end
  def original_filename; end
  def path; end
  def tempfile; end

  private

  def initialize_from_file_path(path); end
  def initialize_from_stringio(stringio); end
  def respond_to_missing?(method_name, include_private = T.unsafe(nil)); end

  class << self
    def actually_finalize(file); end
    def finalize(file); end
  end
end

module Rack::Test::Utils
  include ::Rack::Utils
  extend ::Rack::Utils
  extend ::Rack::Test::Utils

  def build_multipart(params, _first = T.unsafe(nil), multipart = T.unsafe(nil)); end
  def build_nested_query(value, prefix = T.unsafe(nil)); end

  private

  def _build_parts(buffer, parameters); end
  def build_file_part(buffer, parameter_name, uploaded_file); end
  def build_parts(buffer, parameters); end
  def build_primitive_part(buffer, parameter_name, value); end
  def normalize_multipart_params(params, first = T.unsafe(nil)); end
end

Rack::Test::VERSION = T.let(T.unsafe(nil), String)
