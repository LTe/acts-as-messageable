# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `webrick` gem.
# Please instead update this file by running `bin/tapioca gem webrick`.

module WEBrick::AccessLog
  private

  def escape(data); end
  def format(format_string, params); end
  def setup_params(config, req, res); end

  class << self
    def escape(data); end
    def format(format_string, params); end
    def setup_params(config, req, res); end
  end
end

class WEBrick::BasicLog
  def initialize(log_file = T.unsafe(nil), level = T.unsafe(nil)); end

  def <<(obj); end
  def close; end
  def debug(msg); end
  def debug?; end
  def error(msg); end
  def error?; end
  def fatal(msg); end
  def fatal?; end
  def info(msg); end
  def info?; end
  def level; end
  def level=(_arg0); end
  def log(level, data); end
  def warn(msg); end
  def warn?; end

  private

  def format(arg); end
end

class WEBrick::GenericServer
  def initialize(config = T.unsafe(nil), default = T.unsafe(nil)); end

  def [](key); end
  def config; end
  def listen(address, port); end
  def listeners; end
  def logger; end
  def run(sock); end
  def shutdown; end
  def start(&block); end
  def status; end
  def stop; end
  def tokens; end

  private

  def accept_client(svr); end
  def alarm_shutdown_pipe; end
  def call_callback(callback_name, *args); end
  def cleanup_listener; end
  def cleanup_shutdown_pipe(shutdown_pipe); end
  def setup_shutdown_pipe; end
  def start_thread(sock, &block); end
end

module WEBrick::HTMLUtils
  private

  def escape(string); end

  class << self
    def escape(string); end
  end
end

module WEBrick::HTTPAuth
  private

  def _basic_auth(req, res, realm, req_field, res_field, err_type, block); end
  def basic_auth(req, res, realm, &block); end
  def proxy_basic_auth(req, res, realm, &block); end

  class << self
    def _basic_auth(req, res, realm, req_field, res_field, err_type, block); end
    def basic_auth(req, res, realm, &block); end
    def proxy_basic_auth(req, res, realm, &block); end
  end
end

module WEBrick::HTTPAuth::Authenticator
  def logger; end
  def realm; end
  def userdb; end

  private

  def check_init(config); end
  def check_scheme(req); end
  def error(fmt, *args); end
  def info(fmt, *args); end
  def log(meth, fmt, *args); end
end

WEBrick::HTTPAuth::Authenticator::AuthException = WEBrick::HTTPStatus::Unauthorized

class WEBrick::HTTPAuth::BasicAuth
  include ::WEBrick::HTTPAuth::Authenticator

  def initialize(config, default = T.unsafe(nil)); end

  def authenticate(req, res); end
  def challenge(req, res); end
  def logger; end
  def realm; end
  def userdb; end

  class << self
    def make_passwd(realm, user, pass); end
  end
end

class WEBrick::HTTPAuth::DigestAuth
  include ::WEBrick::HTTPAuth::Authenticator

  def initialize(config, default = T.unsafe(nil)); end

  def algorithm; end
  def authenticate(req, res); end
  def challenge(req, res, stale = T.unsafe(nil)); end
  def qop; end

  private

  def _authenticate(req, res); end
  def check_nonce(req, auth_req); end
  def check_opaque(opaque_struct, req, auth_req); end
  def check_uri(req, auth_req); end
  def generate_next_nonce(req); end
  def generate_opaque(req); end
  def hexdigest(*args); end
  def split_param_value(string); end

  class << self
    def make_passwd(realm, user, pass); end
  end
end

class WEBrick::HTTPAuth::Htdigest
  include ::WEBrick::HTTPAuth::UserDB

  def initialize(path); end

  def delete_passwd(realm, user); end
  def each; end
  def flush(output = T.unsafe(nil)); end
  def get_passwd(realm, user, reload_db); end
  def reload; end
  def set_passwd(realm, user, pass); end
end

class WEBrick::HTTPAuth::Htgroup
  def initialize(path); end

  def add(group, members); end
  def flush(output = T.unsafe(nil)); end
  def members(group); end
  def reload; end
end

class WEBrick::HTTPAuth::Htpasswd
  include ::WEBrick::HTTPAuth::UserDB

  def initialize(path, password_hash: T.unsafe(nil)); end

  def delete_passwd(realm, user); end
  def each; end
  def flush(output = T.unsafe(nil)); end
  def get_passwd(realm, user, reload_db); end
  def reload; end
  def set_passwd(realm, user, pass); end
end

WEBrick::HTTPAuth::ProxyAuthenticator::AuthException = WEBrick::HTTPStatus::ProxyAuthenticationRequired

class WEBrick::HTTPAuth::ProxyBasicAuth < ::WEBrick::HTTPAuth::BasicAuth
  include ::WEBrick::HTTPAuth::ProxyAuthenticator
end

class WEBrick::HTTPAuth::ProxyDigestAuth < ::WEBrick::HTTPAuth::DigestAuth
  include ::WEBrick::HTTPAuth::ProxyAuthenticator

  private

  def check_uri(req, auth_req); end
end

module WEBrick::HTTPAuth::UserDB
  def auth_type; end
  def auth_type=(_arg0); end
  def get_passwd(realm, user, reload_db = T.unsafe(nil)); end
  def make_passwd(realm, user, pass); end
  def set_passwd(realm, user, pass); end
end

class WEBrick::HTTPRequest
  def initialize(config); end

  def [](header_name); end
  def accept; end
  def accept_charset; end
  def accept_encoding; end
  def accept_language; end
  def addr; end
  def attributes; end
  def body(&block); end
  def body_reader; end
  def content_length; end
  def content_type; end
  def continue; end
  def cookies; end
  def each; end
  def fixup; end
  def header; end
  def host; end
  def http_version; end
  def keep_alive; end
  def keep_alive?; end
  def meta_vars; end
  def parse(socket = T.unsafe(nil)); end
  def path; end
  def path_info; end
  def path_info=(_arg0); end
  def peeraddr; end
  def port; end
  def query; end
  def query_string; end
  def query_string=(_arg0); end
  def raw_header; end
  def readpartial(size, buf = T.unsafe(nil)); end
  def remote_ip; end
  def request_line; end
  def request_method; end
  def request_time; end
  def request_uri; end
  def script_name; end
  def script_name=(_arg0); end
  def server_name; end
  def ssl?; end
  def to_s; end
  def unparsed_uri; end
  def user; end
  def user=(_arg0); end

  private

  def _read_data(io, method, *arg); end
  def parse_host_request_line(host); end
  def parse_query; end
  def parse_uri(str, scheme = T.unsafe(nil)); end
  def read_body(socket, block); end
  def read_chunk_size(socket); end
  def read_chunked(socket, block); end
  def read_data(io, size); end
  def read_header(socket); end
  def read_line(io, size = T.unsafe(nil)); end
  def read_request_line(socket); end
  def setup_forwarded_info; end
end

WEBrick::HTTPRequest::MAX_HEADER_LENGTH = T.let(T.unsafe(nil), Integer)

class WEBrick::HTTPResponse
  def initialize(config); end

  def [](field); end
  def []=(field, value); end
  def _rack_setup_header; end
  def body; end
  def body=(_arg0); end
  def chunked=(val); end
  def chunked?; end
  def config; end
  def content_length; end
  def content_length=(len); end
  def content_type; end
  def content_type=(type); end
  def cookies; end
  def each; end
  def filename; end
  def filename=(_arg0); end
  def header; end
  def http_version; end
  def keep_alive; end
  def keep_alive=(_arg0); end
  def keep_alive?; end
  def make_body_tempfile; end
  def reason_phrase; end
  def reason_phrase=(_arg0); end
  def remove_body_tempfile; end
  def request_http_version; end
  def request_http_version=(_arg0); end
  def request_method; end
  def request_method=(_arg0); end
  def request_uri; end
  def request_uri=(_arg0); end
  def send_body(socket); end
  def send_header(socket); end
  def send_response(socket); end
  def sent_size; end
  def set_error(ex, backtrace = T.unsafe(nil)); end
  def set_redirect(status, url); end
  def status; end
  def status=(status); end
  def status_line; end
  def upgrade; end
  def upgrade!(protocol); end
  def upgrade=(_arg0); end

  private

  def _write_data(socket, data); end
  def check_header(header_value); end
  def error_body(backtrace, ex, host, port); end
  def send_body_io(socket); end
  def send_body_proc(socket); end
  def send_body_string(socket); end
end

class WEBrick::HTTPResponse::ChunkedWrapper
  def initialize(socket, resp); end

  def <<(*buf); end
  def write(buf); end
end

class WEBrick::HTTPServer < ::WEBrick::GenericServer
  def initialize(config = T.unsafe(nil), default = T.unsafe(nil)); end

  def access_log(config, req, res); end
  def create_request(with_webrick_config); end
  def create_response(with_webrick_config); end
  def do_OPTIONS(req, res); end
  def lookup_server(req); end
  def mount(dir, servlet, *options); end
  def mount_proc(dir, proc = T.unsafe(nil), &block); end
  def run(sock); end
  def search_servlet(path); end
  def service(req, res); end
  def umount(dir); end
  def unmount(dir); end
  def virtual_host(server); end
end

class WEBrick::HTTPServer::MountTable
  def initialize; end

  def [](dir); end
  def []=(dir, val); end
  def delete(dir); end
  def scan(path); end

  private

  def compile; end
  def normalize(dir); end
end

class WEBrick::HTTPServlet::AbstractServlet
  def initialize(server, *options); end

  def do_GET(req, res); end
  def do_HEAD(req, res); end
  def do_OPTIONS(req, res); end
  def service(req, res); end

  private

  def redirect_to_directory_uri(req, res); end

  class << self
    def get_instance(server, *options); end
  end
end

class WEBrick::HTTPServlet::CGIHandler < ::WEBrick::HTTPServlet::AbstractServlet
  def initialize(server, name); end

  def do_GET(req, res); end
  def do_POST(req, res); end
end

WEBrick::HTTPServlet::CGIHandler::CGIRunnerArray = T.let(T.unsafe(nil), Array)

class WEBrick::HTTPServlet::DefaultFileHandler < ::WEBrick::HTTPServlet::AbstractServlet
  def initialize(server, local_path); end

  def do_GET(req, res); end
  def make_partial_content(req, res, filename, filesize); end
  def multipart_body(body, parts, boundary, mtype, filesize); end
  def not_modified?(req, res, mtime, etag); end
  def prepare_range(range, filesize); end
end

class WEBrick::HTTPServlet::ERBHandler < ::WEBrick::HTTPServlet::AbstractServlet
  def initialize(server, name); end

  def do_GET(req, res); end
  def do_POST(req, res); end

  private

  def evaluate(erb, servlet_request, servlet_response); end
end

class WEBrick::HTTPServlet::FileHandler < ::WEBrick::HTTPServlet::AbstractServlet
  def initialize(server, root, options = T.unsafe(nil), default = T.unsafe(nil)); end

  def do_GET(req, res); end
  def do_OPTIONS(req, res); end
  def do_POST(req, res); end
  def service(req, res); end
  def set_filesystem_encoding(str); end

  private

  def call_callback(callback_name, req, res); end
  def check_filename(req, res, name); end
  def exec_handler(req, res); end
  def get_handler(req, res); end
  def nondisclosure_name?(name); end
  def prevent_directory_traversal(req, res); end
  def search_file(req, res, basename); end
  def search_index_file(req, res); end
  def set_dir_list(req, res); end
  def set_filename(req, res); end
  def shift_path_info(req, res, path_info, base = T.unsafe(nil)); end
  def trailing_pathsep?(path); end
  def windows_ambiguous_name?(name); end

  class << self
    def add_handler(suffix, handler); end
    def remove_handler(suffix); end
  end
end

class WEBrick::HTTPServlet::ProcHandler < ::WEBrick::HTTPServlet::AbstractServlet
  def initialize(proc); end

  def do_GET(request, response); end
  def do_POST(request, response); end
  def do_PUT(request, response); end
  def get_instance(server, *options); end
end

module WEBrick::HTTPStatus
  private

  def client_error?(code); end
  def error?(code); end
  def info?(code); end
  def reason_phrase(code); end
  def redirect?(code); end
  def server_error?(code); end
  def success?(code); end

  class << self
    def [](code); end
    def client_error?(code); end
    def error?(code); end
    def info?(code); end
    def reason_phrase(code); end
    def redirect?(code); end
    def server_error?(code); end
    def success?(code); end
  end
end

class WEBrick::HTTPStatus::Status < ::StandardError
  def code; end
  def reason_phrase; end
  def to_i; end

  class << self
    def code; end
    def reason_phrase; end
  end
end

module WEBrick::HTTPUtils
  private

  def _escape(str, regex); end
  def _make_regex(str); end
  def _make_regex!(str); end
  def _unescape(str, regex); end
  def dequote(str); end
  def escape(str); end
  def escape8bit(str); end
  def escape_form(str); end
  def escape_path(str); end
  def load_mime_types(file); end
  def mime_type(filename, mime_tab); end
  def normalize_path(path); end
  def parse_form_data(io, boundary); end
  def parse_header(raw); end
  def parse_query(str); end
  def parse_qvalues(value); end
  def parse_range_header(ranges_specifier); end
  def quote(str); end
  def split_header_value(str); end
  def unescape(str); end
  def unescape_form(str); end

  class << self
    def _escape(str, regex); end
    def _make_regex(str); end
    def _make_regex!(str); end
    def _unescape(str, regex); end
    def dequote(str); end
    def escape(str); end
    def escape8bit(str); end
    def escape_form(str); end
    def escape_path(str); end
    def load_mime_types(file); end
    def mime_type(filename, mime_tab); end
    def normalize_path(path); end
    def parse_form_data(io, boundary); end
    def parse_header(raw); end
    def parse_query(str); end
    def parse_qvalues(value); end
    def parse_range_header(ranges_specifier); end
    def quote(str); end
    def split_header_value(str); end
    def unescape(str); end
    def unescape_form(str); end
  end
end

class WEBrick::HTTPUtils::FormData < ::String
  def initialize(*args); end

  def <<(str); end
  def [](*key); end
  def append_data(data); end
  def each_data; end
  def filename; end
  def filename=(_arg0); end
  def list; end
  def name; end
  def name=(_arg0); end
  def next_data=(_arg0); end
  def to_ary; end
  def to_s; end

  protected

  def next_data; end
end

module WEBrick::Utils
  private

  def create_listeners(address, port); end
  def getservername; end
  def random_string(len); end
  def set_close_on_exec(io); end
  def set_non_blocking(io); end
  def su(user); end
  def timeout(seconds, exception = T.unsafe(nil)); end

  class << self
    def create_listeners(address, port); end
    def getservername; end
    def random_string(len); end
    def set_close_on_exec(io); end
    def set_non_blocking(io); end
    def su(user); end
    def timeout(seconds, exception = T.unsafe(nil)); end
  end
end

class WEBrick::Utils::TimeoutHandler
  include ::Singleton
  extend ::Singleton::SingletonClassMethods

  def initialize; end

  def cancel(thread, id); end
  def interrupt(thread, id, exception); end
  def register(thread, time, exception); end
  def terminate; end

  private

  def watch; end
  def watcher; end

  class << self
    def cancel(id); end
    def register(seconds, exception); end
    def terminate; end
  end
end
