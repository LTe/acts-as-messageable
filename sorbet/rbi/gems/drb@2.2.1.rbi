# typed: false

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `drb` gem.
# Please instead update this file by running `bin/tapioca gem drb`.

module DRb
  private

  def config; end
  def current_server; end
  def fetch_server(uri); end
  def front; end
  def here?(uri); end
  def install_acl(acl); end
  def install_id_conv(idconv); end
  def mutex; end
  def primary_server; end
  def primary_server=(_arg0); end
  def regist_server(server); end
  def remove_server(server); end
  def start_service(uri = T.unsafe(nil), front = T.unsafe(nil), config = T.unsafe(nil)); end
  def stop_service; end
  def thread; end
  def to_id(obj); end
  def to_obj(ref); end
  def uri; end

  class << self
    def config; end
    def current_server; end
    def fetch_server(uri); end
    def front; end
    def here?(uri); end
    def install_acl(acl); end
    def install_id_conv(idconv); end
    def mutex; end
    def primary_server; end
    def primary_server=(_arg0); end
    def regist_server(server); end
    def remove_server(server); end
    def start_service(uri = T.unsafe(nil), front = T.unsafe(nil), config = T.unsafe(nil)); end
    def stop_service; end
    def thread; end
    def to_id(obj); end
    def to_obj(ref); end
    def uri; end
  end
end

class DRb::DRbArray
  def initialize(ary); end

  def _dump(lv); end

  class << self
    def _load(s); end
  end
end

class DRb::DRbConn
  def initialize(remote_uri); end

  def alive?; end
  def close; end
  def send_message(ref, msg_id, arg, block); end
  def uri; end

  class << self
    def make_pool; end
    def open(remote_uri); end
    def stop_pool; end
  end
end

class DRb::DRbIdConv
  def to_id(obj); end
  def to_obj(ref); end
end

class DRb::DRbMessage
  def initialize(config); end

  def dump(obj, error = T.unsafe(nil)); end
  def load(soc); end
  def recv_reply(stream); end
  def recv_request(stream); end
  def send_reply(stream, succ, result); end
  def send_request(stream, ref, msg_id, arg, b); end

  private

  def make_proxy(obj, error = T.unsafe(nil)); end
end

class DRb::DRbObject
  def initialize(obj, uri = T.unsafe(nil)); end

  def ==(other); end
  def __drbref; end
  def __drburi; end
  def _dump(lv); end
  def eql?(other); end
  def hash; end
  def method_missing(msg_id, *a, **_arg2, &b); end
  def pretty_print(q); end
  def pretty_print_cycle(q); end
  def respond_to?(msg_id, priv = T.unsafe(nil)); end

  class << self
    def _load(s); end
    def new_with(uri, ref); end
    def new_with_uri(uri); end
    def prepare_backtrace(uri, result); end
    def with_friend(uri); end
  end
end

module DRb::DRbProtocol
  private

  def add_protocol(prot); end
  def auto_load(uri); end
  def open(uri, config, first = T.unsafe(nil)); end
  def open_server(uri, config, first = T.unsafe(nil)); end
  def uri_option(uri, config, first = T.unsafe(nil)); end

  class << self
    def add_protocol(prot); end
    def auto_load(uri); end
    def open(uri, config, first = T.unsafe(nil)); end
    def open_server(uri, config, first = T.unsafe(nil)); end
    def uri_option(uri, config, first = T.unsafe(nil)); end
  end
end

class DRb::DRbRemoteError < ::DRb::DRbError
  def initialize(error); end

  def reason; end
end

class DRb::DRbServer
  def initialize(uri = T.unsafe(nil), front = T.unsafe(nil), config_or_acl = T.unsafe(nil)); end

  def alive?; end
  def check_insecure_method(obj, msg_id); end
  def config; end
  def front; end
  def here?(uri); end
  def stop_service; end
  def thread; end
  def to_id(obj); end
  def to_obj(ref); end
  def uri; end
  def verbose; end
  def verbose=(v); end

  private

  def any_to_s(obj); end
  def error_print(exception); end
  def insecure_method?(msg_id); end
  def main_loop; end
  def run; end
  def shutdown; end

  class << self
    def default_acl(acl); end
    def default_argc_limit(argc); end
    def default_id_conv(idconv); end
    def default_load_limit(sz); end
    def make_config(hash = T.unsafe(nil)); end
    def verbose; end
    def verbose=(on); end
  end
end

class DRb::DRbServer::InvokeMethod
  include ::DRb::DRbServer::InvokeMethod18Mixin

  def initialize(drb_server, client); end

  def perform; end

  private

  def check_insecure_method; end
  def init_with_client; end
  def perform_without_block; end
  def setup_message; end
end

module DRb::DRbServer::InvokeMethod18Mixin
  def block_yield(x); end
  def perform_with_block; end
end

class DRb::DRbTCPSocket
  def initialize(uri, soc, config = T.unsafe(nil)); end

  def accept; end
  def alive?; end
  def close; end
  def peeraddr; end
  def recv_reply; end
  def recv_request; end
  def send_reply(succ, result); end
  def send_request(ref, msg_id, arg, b); end
  def set_sockopt(soc); end
  def shutdown; end
  def stream; end
  def uri; end

  private

  def accept_or_shutdown; end
  def close_shutdown_pipe; end

  class << self
    def getservername; end
    def open(uri, config); end
    def open_server(uri, config); end
    def open_server_inaddr_any(host, port); end
    def parse_uri(uri); end
    def uri_option(uri, config); end
  end
end

class DRb::DRbUNIXSocket < ::DRb::DRbTCPSocket
  def initialize(uri, soc, config = T.unsafe(nil), server_mode = T.unsafe(nil)); end

  def accept; end
  def close; end
  def set_sockopt(soc); end

  class << self
    def open(uri, config); end
    def open_server(uri, config); end
    def parse_uri(uri); end
    def temp_server; end
    def uri_option(uri, config); end
  end
end

DRb::DRbUNIXSocket::Max_try = T.let(T.unsafe(nil), Integer)

class DRb::DRbURIOption
  def initialize(option); end

  def ==(other); end
  def eql?(other); end
  def hash; end
  def option; end
  def to_s; end
end

module DRb::DRbUndumped
  def _dump(dummy); end
end

class DRb::DRbUnknown
  def initialize(err, buf); end

  def _dump(lv); end
  def buf; end
  def exception; end
  def name; end
  def reload; end

  class << self
    def _load(s); end
  end
end

class DRb::DRbUnknownError < ::DRb::DRbError
  def initialize(unknown); end

  def _dump(lv); end
  def unknown; end

  class << self
    def _load(s); end
  end
end

class DRb::ThreadObject
  include ::MonitorMixin

  def initialize(&blk); end

  def _execute; end
  def alive?; end
  def kill; end
  def method_missing(msg, *arg, &blk); end
end

DRb::VERSION = T.let(T.unsafe(nil), String)
DRbIdConv = DRb::DRbIdConv
DRbObject = DRb::DRbObject
DRbUndumped = DRb::DRbUndumped
