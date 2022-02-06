# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: ignore
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/github_api/all/github_api.rbi
#
# github_api-0.16.0

module Github
  def self.default_middleware(options = nil); end
  def self.deprecate(method, alternate_method = nil); end
  def self.deprecation_tracker; end
  def self.deprecation_tracker=(arg0); end
  def self.included(base); end
  def self.method_missing(method_name, *args, &block); end
  def self.new(options = nil, &block); end
  def self.respond_to?(method_name, include_private = nil); end
  def self.warn_deprecation(message); end
  extend Github::ClassMethods
end
class Github::API
  def adapter; end
  def adapter=(arg); end
  def api_methods_in(klass); end
  def auto_pagination; end
  def auto_pagination=(arg); end
  def basic_auth; end
  def basic_auth=(arg); end
  def client_id; end
  def client_id=(arg); end
  def client_secret; end
  def client_secret=(arg); end
  def connection_options; end
  def connection_options=(arg); end
  def current_options; end
  def current_options=(arg0); end
  def disable_redirects; end
  def endpoint; end
  def endpoint=(arg); end
  def extract_basic_auth(auth); end
  def follow_redirects; end
  def follow_redirects=(arg); end
  def initialize(options = nil, &block); end
  def jsonp_callback; end
  def jsonp_callback=(arg0); end
  def login; end
  def login=(arg); end
  def mime_type; end
  def mime_type=(arg); end
  def module_methods_in(klass); end
  def oauth_token; end
  def oauth_token=(arg); end
  def org; end
  def org=(arg); end
  def page; end
  def page=(arg0); end
  def password; end
  def password=(arg); end
  def per_page; end
  def per_page=(arg); end
  def repo; end
  def repo=(arg); end
  def self.after_callbacks; end
  def self.after_request(callback, params = nil); end
  def self.before_callbacks; end
  def self.before_request(callback, params = nil); end
  def self.clear_request_methods!; end
  def self.extend_with_actions(child_class); end
  def self.extra_methods; end
  def self.extract_class_name(name, options); end
  def self.inherited(child_class); end
  def self.internal_methods; end
  def self.method_added(method_name); end
  def self.namespace(*names); end
  def self.request_methods; end
  def self.root!; end
  def self.root; end
  def self.root?; end
  def site; end
  def site=(arg); end
  def ssl; end
  def ssl=(arg); end
  def stack; end
  def stack=(arg); end
  def upload_endpoint; end
  def upload_endpoint=(arg); end
  def user; end
  def user=(arg); end
  def user_agent; end
  def user_agent=(arg); end
  def yield_or_eval(&block); end
  extend Github::ClassMethods
  include Github::Authorization
  include Github::Constants
  include Github::MimeType
  include Github::RateLimit
  include Github::Request::Verbs
end
class Github::API::Config
  def call(&block); end
  def fetch(value = nil); end
  def initialize(&block); end
  def property_names; end
  def self.inherited(descendant); end
  def self.property(name, options = nil); end
  def self.property?(name); end
  def self.property_names; end
  def self.property_set; end
  def self.update_subclasses(name, options); end
end
class Github::API::Config::Property
  def default; end
  def define_accessor_methods(properties); end
  def initialize(name, options); end
  def name; end
  def required; end
end
class Github::API::Config::PropertySet
  def <<(property); end
  def [](name); end
  def []=(name, property); end
  def define_reader_method(property, method_name, visibility); end
  def define_writer_method(property, method_name, visibility); end
  def each; end
  def empty?; end
  def fetch(name); end
  def initialize(parent = nil, properties = nil); end
  def parent; end
  def properties; end
  def to_hash; end
  def update_map(name, property); end
  include Enumerable
end
class Github::Configuration < Github::API::Config
  def adapter; end
  def adapter=(value); end
  def auto_pagination; end
  def auto_pagination=(value); end
  def basic_auth; end
  def basic_auth=(value); end
  def client_id; end
  def client_id=(value); end
  def client_secret; end
  def client_secret=(value); end
  def connection_options; end
  def connection_options=(value); end
  def endpoint; end
  def endpoint=(value); end
  def follow_redirects; end
  def follow_redirects=(value); end
  def login; end
  def login=(value); end
  def mime_type; end
  def mime_type=(value); end
  def oauth_token; end
  def oauth_token=(value); end
  def org; end
  def org=(value); end
  def password; end
  def password=(value); end
  def per_page; end
  def per_page=(value); end
  def repo; end
  def repo=(value); end
  def site; end
  def site=(value); end
  def ssl; end
  def ssl=(value); end
  def stack; end
  def stack=(value); end
  def upload_endpoint; end
  def upload_endpoint=(value); end
  def user; end
  def user=(value); end
  def user_agent; end
  def user_agent=(value); end
end
module Github::Constants
  extend Github::Constants
end
module Github::Utils
end
module Github::Utils::Url
  def build_query(params); end
  def escape(s); end
  def escape_uri(s); end
  def normalize(s); end
  def parse_query(query_string); end
  def parse_query_for_param(query_string, name); end
  def unescape(s); end
  extend Github::Utils::Url
end
module Github::Connection
  def connection(api, options = nil); end
  def default_headers; end
  def default_options(options = nil); end
  def stack(options = nil); end
  extend Github::Connection
  include Github::Constants
end
module Github::CoreExt
end
class Github::CoreExt::OrderedHash < Hash
end
module Faraday
end
module Faraday::Utils
end
class Faraday::Utils::ParamsHash < Hash
  def params_encoder(encoder = nil); end
end
class Github::Response < Faraday::Response::Middleware
  def initialize(app, options = nil); end
  def parse_body?(env); end
  def parse_response?(env); end
  def parse_response_type?(type); end
  def process_body(env); end
  def response_type(env); end
  def self.define_parser(&block); end
  def self.parser; end
  def self.parser=(arg0); end
end
class Github::Mash < Hashie::Mash
end
class Github::Response::Mashify < Github::Response
  def parse(body); end
end
class Github::Response::Jsonize < Github::Response
  def parse(body); end
end
class Github::Response::AtomParser < Github::Response
  def initialize(app, options = nil); end
  def on_complete(env); end
end
module Github::Error
end
class Github::Error::ServiceError < Github::Error::GithubError
  def create_error_summary; end
  def create_message(response); end
  def data; end
  def decode_data(body); end
  def error_messages; end
  def format_response; end
  def initialize(response); end
  def self.error_mapping; end
  def self.http_status_code(code); end
end
class Github::Error::BadRequest < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::Unauthorized < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::Forbidden < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::NotFound < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::MethodNotAllowed < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::NotAcceptable < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::Conflict < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::UnsupportedMediaType < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::UnprocessableEntity < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::UnavailableForLegalReasons < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::InternalServerError < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::NotImplemented < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::BadGateway < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::ServiceUnavailable < Github::Error::ServiceError
  def http_status_code; end
end
class Github::Error::ClientError < Github::Error::GithubError
  def generate_message(attributes); end
  def initialize(message); end
  def problem; end
  def resolution; end
  def summary; end
end
class Github::Error::InvalidOptions < Github::Error::ClientError
  def initialize(invalid, valid); end
end
class Github::Error::RequiredParams < Github::Error::ClientError
  def initialize(provided, required); end
end
class Github::Error::UnknownMedia < Github::Error::ClientError
  def initialize(file); end
end
class Github::Error::UnknownValue < Github::Error::ClientError
  def initialize(key, value, permitted); end
end
class Github::Error::Validations < Github::Error::ClientError
  def initialize(errors); end
end
class Github::Error::GithubError < StandardError
  def backtrace; end
  def initialize(message = nil); end
  def response_headers; end
  def response_message; end
  extend DescendantsTracker
end
class Github::Response::RaiseError < Faraday::Response::Middleware
  def on_complete(env); end
end
class Anonymous_Struct_20 < Struct
  def env; end
  def env=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
end
class Github::Response::Header < Anonymous_Struct_20
  def [](property); end
  def accepted_oauth_scopes; end
  def body; end
  def cache_control; end
  def content_length; end
  def content_type; end
  def date; end
  def etag; end
  def loaded?; end
  def location; end
  def oauth_scopes; end
  def ratelimit_limit; end
  def ratelimit_remaining; end
  def ratelimit_reset; end
  def server; end
  def status; end
  def success?; end
  include Github::Constants
end
class Github::RedirectLimitReached < Faraday::ClientError
  def initialize(response); end
  def response; end
end
class Github::Response::FollowRedirects < Faraday::Middleware
  def call(env); end
  def callback; end
  def convert_to_get?(response); end
  def follow_limit; end
  def follow_redirect?(env, response); end
  def initialize(app, options = nil); end
  def perform_with_redirection(env, follows); end
  def safe_escape(uri); end
  def standards_compliant?; end
  def update_env(env, request_body, response); end
end
class Github::Middleware
  def self.default(options = nil); end
end
module Github::Authorization
  def _verify_client; end
  def auth_code; end
  def authenticated?; end
  def authentication; end
  def authorize_url(params = nil); end
  def basic_authed?; end
  def client; end
  def get_token(authorization_code, params = nil); end
end
module Github::Validations
  include Github::Validations::Format
  include Github::Validations::Presence
  include Github::Validations::Required
  include Github::Validations::Token
end
module Github::Validations::Presence
  def assert_presence_of(*args); end
end
module Github::Validations::Token
  def validates_token_for(method, path); end
end
module Github::Validations::Format
  def assert_valid_values(permitted, params); end
end
module Github::Validations::Required
  def assert_required_keys(*required, provided); end
end
module Github::Normalizer
  def normalize!(params); end
end
module Github::ParameterFilter
  def filter!(keys, params, options = nil); end
end
module Github::MimeType
  def lookup_media(name); end
  def parse(media); end
end
module Github::RateLimit
  def ratelimit(*args); end
  def ratelimit_remaining(*args); end
  def ratelimit_reset(*args); end
end
class Hash
  def deep_key?(key); end
  def deep_keys; end
  def serialize; end
end
class Array
  def except!(*items); end
  def except(*keys); end
end
module Github::NullParamsEncoder
  def self.escape(s); end
  def self.unescape(s); end
end
class Github::Request
  def action; end
  def api; end
  def call(current_options, params); end
  def initialize(action, path, api); end
  def path; end
  def path=(arg0); end
  include Github::Connection
end
module Github::Request::Verbs
  def delete_request(path, params = nil); end
  def get_request(path, params = nil); end
  def head_request(path, params = nil); end
  def options_request(path, params = nil); end
  def patch_request(path, params = nil); end
  def post_request(path, params = nil); end
  def put_request(path, params = nil); end
end
class Github::API::Factory
  def self.convert_to_constant(classes); end
  def self.create_instance(klass, options, &block); end
  def self.new(klass, options = nil, &block); end
end
class Github::API::Arguments
  def [](property); end
  def []=(property, value); end
  def api; end
  def api_property?(property); end
  def assert_required(*required); end
  def assert_values(values, key = nil); end
  def check_requirement!(*args); end
  def extract_pagination(options); end
  def initialize(options = nil, &block); end
  def method_missing(method_name, *args, &block); end
  def optional(*attrs, &block); end
  def params; end
  def parse(*args, &block); end
  def parse_array(*args); end
  def parse_hash(options); end
  def permit(keys, key = nil, options = nil); end
  def remaining; end
  def remove_required(options, key, val); end
  def require(*attrs, &block); end
  def required(*attrs, &block); end
  def respond_to_missing?(method_name, include_private = nil); end
  def update_required_from_global; end
  def yield_or_eval(&block); end
  include Github::Normalizer
  include Github::ParameterFilter
  include Github::Validations
end
class Github::Client::Activity::Events < Github::API
  def self.actions; end
end
class Github::Client::Activity::Notifications < Github::API
  def self.actions; end
end
class Github::Client::Activity::Feeds < Github::API
  def self.actions; end
end
class Github::Client::Activity::Starring < Github::API
  def self.actions; end
end
class Github::Client::Activity::Watching < Github::API
  def self.actions; end
end
class Github::Client::Activity < Github::API
  def self.actions; end
end
class Github::Client::Authorizations::App < Github::Client::Authorizations
  def self.actions; end
end
class Github::Client::Authorizations < Github::API
  def self.actions; end
end
class Github::Client::Emojis < Github::API
  def self.actions; end
end
class Github::Client::Gists::Comments < Github::API
  def self.actions; end
end
class Github::Client::Gists < Github::API
  def self.actions; end
end
class Github::Client::Gitignore < Github::API
  def self.actions; end
end
class Github::Client::GitData::Blobs < Github::API
  def self.actions; end
end
class Github::Client::GitData::Commits < Github::API
  def self.actions; end
end
class Github::Client::GitData::References < Github::API
  def self.actions; end
end
class Github::Client::GitData::Tags < Github::API
  def self.actions; end
end
class Github::Client::GitData::Trees < Github::API
  def self.actions; end
end
class Github::Client::GitData < Github::API
  def self.actions; end
end
class Github::Client::Issues::Assignees < Github::API
  def self.actions; end
end
class Github::Client::Issues::Comments < Github::API
  def self.actions; end
end
class Github::Client::Issues::Events < Github::API
  def self.actions; end
end
class Github::Client::Issues::Labels < Github::API
  def self.actions; end
end
class Github::Client::Issues::Milestones < Github::API
  def self.actions; end
end
class Github::Client::Issues < Github::API
  def self.actions; end
end
class Github::Client::Markdown < Github::API
  def self.actions; end
end
class Github::Client::Meta < Github::API
  def self.actions; end
end
class Github::Client::Orgs::Hooks < Github::API
  def self.actions; end
end
class Github::Client::Orgs::Members < Github::API
  def self.actions; end
end
class Github::Client::Orgs::Memberships < Github::API
  def self.actions; end
end
class Github::Client::Orgs::Teams < Github::API
  def self.actions; end
end
class Github::Client::Orgs < Github::API
  def self.actions; end
end
class Github::Client::PullRequests::Comments < Github::API
  def self.actions; end
end
class Github::Client::PullRequests::Reviews < Github::API
  def self.actions; end
end
class Github::Client::PullRequests < Github::API
  def self.actions; end
end
class Github::Client::Repos::Collaborators < Github::API
  def self.actions; end
end
class Github::Client::Repos::Comments < Github::API
  def self.actions; end
end
class Github::Client::Repos::Commits < Github::API
  def self.actions; end
end
class Github::Client::Repos::Contents < Github::API
  def self.actions; end
end
class Github::Client::Repos::Deployments < Github::API
  def self.actions; end
end
class Github::Client::Repos::Downloads < Github::API
  def self.actions; end
end
class Github::Client::Repos::Forks < Github::API
  def self.actions; end
end
class Github::Client::Repos::Hooks < Github::API
  def self.actions; end
end
class Github::Client::Repos::Keys < Github::API
  def self.actions; end
end
class Github::Client::Repos::Merging < Github::API
  def self.actions; end
end
class Github::Client::Repos::Pages < Github::API
  def self.actions; end
end
class Github::Client::Repos::PubSubHubbub < Github::API
  def self.actions; end
end
class Github::Client::Repos::Releases::Assets < Github::API
  def self.actions; end
end
class Github::Client::Repos::Releases::Tags < Github::API
  def self.actions; end
end
class Github::Client::Repos::Releases < Github::API
  def self.actions; end
end
class Github::Client::Repos::Statistics < Github::API
  def self.actions; end
end
class Github::Client::Repos::Statuses < Github::API
  def self.actions; end
end
class Github::Client::Repos < Github::API
  def self.actions; end
end
class Github::Client::Say < Github::API
  def self.actions; end
end
class Github::Client::Scopes < Github::API
  def self.actions; end
end
class Github::Client::Search::Legacy < Github::API
  def self.actions; end
  include Github::Utils::Url
end
class Github::Client::Search < Github::API
  def self.actions; end
  include Github::Utils::Url
end
class Github::Client::Users::Emails < Github::API
  def self.actions; end
end
class Github::Client::Users::Followers < Github::API
  def self.actions; end
end
class Github::Client::Users::Keys < Github::API
  def self.actions; end
end
class Github::Client::Users < Github::API
  def self.actions; end
end
class Github::Client < Github::API
  def self.actions; end
end
module Github::Pagination
  def auto_paginate(auto = nil); end
  def count_pages; end
  def each_page; end
  def first_page; end
  def has_next_page?; end
  def last_page; end
  def links; end
  def next_page; end
  def page(page_number); end
  def page_iterator; end
  def prev_page; end
  def previous_page; end
  def self.per_page_as_param(per_page_config); end
  include Github::Constants
end
class Github::Request::OAuth2 < Faraday::Middleware
  def call(env); end
  def initialize(app, *args); end
  def query_params(url); end
  include Github::Utils::Url
end
class Github::Request::BasicAuth < Faraday::Middleware
  def call(env); end
  def initialize(app, *args); end
end
class Github::Request::Jsonize < Faraday::Middleware
  def call(env); end
  def encode_body(value); end
  def has_body?(env); end
  def request_type(env); end
  def request_with_body?(env); end
  def safe_to_modify?(env); end
end
class Github::ResponseWrapper
  def ==(other); end
  def [](key); end
  def body; end
  def body=(value); end
  def client_error?; end
  def current_api; end
  def each; end
  def empty?(*args, &block); end
  def env; end
  def eql?(other); end
  def first(*args, &block); end
  def flatten(*args, &block); end
  def fork; end
  def has_key?(key); end
  def headers; end
  def id; end
  def include?(*args, &block); end
  def initialize(response, current_api); end
  def inspect; end
  def keys(*args, &block); end
  def length(*args, &block); end
  def method_missing(method_name, *args, &block); end
  def redirect?; end
  def respond_to?(method_name, include_all = nil); end
  def response; end
  def server_error?; end
  def size(*args, &block); end
  def status; end
  def success?; end
  def to_a(*args, &block); end
  def to_ary; end
  def to_hash; end
  def to_s; end
  def type; end
  def url; end
  extend Forwardable
  include Enumerable
  include Github::Pagination
end
class Github::PageLinks
  def assign_url_part(meta_part, url_part); end
  def extract_links(link_header); end
  def first; end
  def first=(arg0); end
  def initialize(response_headers); end
  def last; end
  def last=(arg0); end
  def next; end
  def next=(arg0); end
  def prev; end
  def prev=(arg0); end
  include Github::Constants
end
module Github::PagedRequest
  def default_page; end
  def default_page_size; end
  def page_request(path, params = nil); end
  include Github::Constants
end
class Github::PageIterator
  def count; end
  def current_api; end
  def first; end
  def first_page; end
  def first_page=(arg0); end
  def first_page_uri; end
  def first_page_uri=(arg0); end
  def get_page(page_number); end
  def initialize(links, current_api); end
  def last; end
  def last_page; end
  def last_page=(arg0); end
  def last_page_uri; end
  def last_page_uri=(arg0); end
  def next; end
  def next?; end
  def next_page; end
  def next_page=(arg0); end
  def next_page_uri; end
  def next_page_uri=(arg0); end
  def parse_page_number(uri); end
  def parse_page_params(uri, attr); end
  def parse_per_page_number(uri); end
  def perform_request(page_uri_path, page_number = nil); end
  def prev; end
  def prev_page; end
  def prev_page=(arg0); end
  def prev_page_uri; end
  def prev_page_uri=(arg0); end
  def sha(params); end
  def update_page_links(links); end
  include Github::Constants
  include Github::PagedRequest
  include Github::Utils::Url
end
class Github::ParamsHash < Anonymous_Delegator_21
  def accept; end
  def data; end
  def encoder; end
  def initialize(hash); end
  def media; end
  def merge_default(defaults); end
  def options; end
  def request_params; end
  def self.empty; end
  def strict_encode64(key); end
  include Github::MimeType
  include Github::Normalizer
end
module Github::ClassMethods
  def config; end
  def configuration; end
  def configure; end
  def require_all(prefix, *libs); end
end
