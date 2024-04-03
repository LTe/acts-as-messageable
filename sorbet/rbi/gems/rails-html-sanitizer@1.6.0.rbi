# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rails-html-sanitizer` gem.
# Please instead update this file by running `bin/tapioca gem rails-html-sanitizer`.

module ActionView
  class << self
    def deprecator; end
    def eager_load!; end
    def gem_version; end
    def version; end
  end
end

module ActionView::Helpers
  include ::ActionView::Helpers::SanitizeHelper
  include ::ActionView::Helpers::TextHelper
  include ::ActionView::Helpers::UrlHelper
  include ::ActionView::Helpers::SanitizeHelper
  include ::ActionView::Helpers::TextHelper
  include ::ActionView::Helpers::FormTagHelper
  include ::ActionView::Helpers::FormHelper
  include ::ActionView::Helpers::TranslationHelper

  mixes_in_class_methods ::ActionView::Helpers::UrlHelper::ClassMethods
  mixes_in_class_methods ::ActionView::Helpers::SanitizeHelper::ClassMethods

  class << self
    def eager_load!; end
  end
end

module ActionView::Helpers::SanitizeHelper
  mixes_in_class_methods ::ActionView::Helpers::SanitizeHelper::ClassMethods

  def sanitize(html, options = T.unsafe(nil)); end
  def sanitize_css(style); end
  def sanitizer_vendor; end
  def sanitizer_vendor=(val); end
  def strip_links(html); end
  def strip_tags(html); end

  class << self
    def sanitizer_vendor; end
    def sanitizer_vendor=(val); end
  end
end

module ActionView::Helpers::SanitizeHelper::ClassMethods
  def full_sanitizer; end
  def full_sanitizer=(_arg0); end
  def link_sanitizer; end
  def link_sanitizer=(_arg0); end
  def safe_list_sanitizer; end
  def safe_list_sanitizer=(_arg0); end
  def sanitized_allowed_attributes; end
  def sanitized_allowed_attributes=(attributes); end
  def sanitized_allowed_css_keywords; end
  def sanitized_allowed_css_keywords=(_); end
  def sanitized_allowed_css_properties; end
  def sanitized_allowed_css_properties=(_); end
  def sanitized_allowed_protocols; end
  def sanitized_allowed_protocols=(_); end
  def sanitized_allowed_tags; end
  def sanitized_allowed_tags=(tags); end
  def sanitized_bad_tags; end
  def sanitized_bad_tags=(_); end
  def sanitized_protocol_separator; end
  def sanitized_protocol_separator=(_); end
  def sanitized_shorthand_css_properties; end
  def sanitized_shorthand_css_properties=(_); end
  def sanitized_uri_attributes; end
  def sanitized_uri_attributes=(_); end
  def sanitizer_vendor; end

  private

  def deprecate_option(name); end
end

module Rails
  class << self
    def app_class; end
    def app_class=(_arg0); end
    def application; end
    def application=(_arg0); end
    def autoloaders; end
    def backtrace_cleaner; end
    def cache; end
    def cache=(_arg0); end
    def configuration; end
    def deprecator; end
    def env; end
    def env=(environment); end
    def error; end
    def gem_version; end
    def groups(*groups); end
    def initialize!(*_arg0, **_arg1, &_arg2); end
    def initialized?(*_arg0, **_arg1, &_arg2); end
    def logger; end
    def logger=(_arg0); end
    def public_path; end
    def root; end
    def version; end
  end
end

module Rails::HTML; end
module Rails::HTML4; end

class Rails::HTML4::FullSanitizer < ::Rails::HTML::Sanitizer
  include ::Rails::HTML::Concern::ComposedSanitize
  include ::Rails::HTML::Concern::Parser::HTML4
  include ::Rails::HTML::Concern::Scrubber::Full
  include ::Rails::HTML::Concern::Serializer::UTF8Encode
end

class Rails::HTML4::LinkSanitizer < ::Rails::HTML::Sanitizer
  include ::Rails::HTML::Concern::ComposedSanitize
  include ::Rails::HTML::Concern::Parser::HTML4
  include ::Rails::HTML::Concern::Scrubber::Link
  include ::Rails::HTML::Concern::Serializer::UTF8Encode
end

class Rails::HTML4::SafeListSanitizer < ::Rails::HTML::Sanitizer
  include ::Rails::HTML::Concern::ComposedSanitize
  include ::Rails::HTML::Concern::Parser::HTML4
  include ::Rails::HTML::Concern::Scrubber::SafeList
  include ::Rails::HTML::Concern::Serializer::UTF8Encode

  class << self
    def allowed_attributes; end
    def allowed_attributes=(_arg0); end
    def allowed_tags; end
    def allowed_tags=(_arg0); end
  end
end

module Rails::HTML4::Sanitizer
  extend ::Rails::HTML4::Sanitizer::VendorMethods
end

module Rails::HTML4::Sanitizer::VendorMethods
  def full_sanitizer; end
  def link_sanitizer; end
  def safe_list_sanitizer; end
  def white_list_sanitizer; end
end

module Rails::HTML5; end

class Rails::HTML5::FullSanitizer < ::Rails::HTML::Sanitizer
  include ::Rails::HTML::Concern::ComposedSanitize
  include ::Rails::HTML::Concern::Parser::HTML5
  include ::Rails::HTML::Concern::Scrubber::Full
  include ::Rails::HTML::Concern::Serializer::UTF8Encode
end

class Rails::HTML5::LinkSanitizer < ::Rails::HTML::Sanitizer
  include ::Rails::HTML::Concern::ComposedSanitize
  include ::Rails::HTML::Concern::Parser::HTML5
  include ::Rails::HTML::Concern::Scrubber::Link
  include ::Rails::HTML::Concern::Serializer::UTF8Encode
end

class Rails::HTML5::SafeListSanitizer < ::Rails::HTML::Sanitizer
  include ::Rails::HTML::Concern::ComposedSanitize
  include ::Rails::HTML::Concern::Parser::HTML5
  include ::Rails::HTML::Concern::Scrubber::SafeList
  include ::Rails::HTML::Concern::Serializer::UTF8Encode

  class << self
    def allowed_attributes; end
    def allowed_attributes=(_arg0); end
    def allowed_tags; end
    def allowed_tags=(_arg0); end
  end
end

class Rails::HTML5::Sanitizer
  class << self
    def full_sanitizer; end
    def link_sanitizer; end
    def safe_list_sanitizer; end
    def white_list_sanitizer; end
  end
end

module Rails::HTML::Concern; end

module Rails::HTML::Concern::ComposedSanitize
  def sanitize(html, options = T.unsafe(nil)); end
end

module Rails::HTML::Concern::Parser; end

module Rails::HTML::Concern::Parser::HTML4
  def parse_fragment(html); end
end

module Rails::HTML::Concern::Parser::HTML5
  def parse_fragment(html); end
end

module Rails::HTML::Concern::Scrubber; end

module Rails::HTML::Concern::Scrubber::Full
  def scrub(fragment, options = T.unsafe(nil)); end
end

module Rails::HTML::Concern::Scrubber::Link
  def initialize; end

  def scrub(fragment, options = T.unsafe(nil)); end
end

module Rails::HTML::Concern::Scrubber::SafeList
  def initialize(prune: T.unsafe(nil)); end

  def sanitize_css(style_string); end
  def scrub(fragment, options = T.unsafe(nil)); end

  private

  def allowed_attributes(options); end
  def allowed_tags(options); end

  class << self
    def included(klass); end
  end
end

Rails::HTML::Concern::Scrubber::SafeList::DEFAULT_ALLOWED_ATTRIBUTES = T.let(T.unsafe(nil), Set)
Rails::HTML::Concern::Scrubber::SafeList::DEFAULT_ALLOWED_TAGS = T.let(T.unsafe(nil), Set)
module Rails::HTML::Concern::Serializer; end

module Rails::HTML::Concern::Serializer::UTF8Encode
  def serialize(fragment); end
end

Rails::HTML::FullSanitizer = Rails::HTML4::FullSanitizer
Rails::HTML::LinkSanitizer = Rails::HTML4::LinkSanitizer

class Rails::HTML::PermitScrubber < ::Loofah::Scrubber
  def initialize(prune: T.unsafe(nil)); end

  def attributes; end
  def attributes=(attributes); end
  def prune; end
  def scrub(node); end
  def tags; end
  def tags=(tags); end

  protected

  def allowed_node?(node); end
  def keep_node?(node); end
  def scrub_attribute(node, attr_node); end
  def scrub_attribute?(name); end
  def scrub_attributes(node); end
  def scrub_css_attribute(node); end
  def scrub_node(node); end
  def skip_node?(node); end
  def validate!(var, name); end
end

Rails::HTML::SafeListSanitizer = Rails::HTML4::SafeListSanitizer

class Rails::HTML::Sanitizer
  extend ::Rails::HTML4::Sanitizer::VendorMethods

  def sanitize(html, options = T.unsafe(nil)); end

  private

  def properly_encode(fragment, options); end
  def remove_xpaths(node, xpaths); end

  class << self
    def best_supported_vendor; end
    def html5_support?; end
  end
end

Rails::HTML::Sanitizer::VERSION = T.let(T.unsafe(nil), String)

class Rails::HTML::TargetScrubber < ::Rails::HTML::PermitScrubber
  def allowed_node?(node); end
  def scrub_attribute?(name); end
end

class Rails::HTML::TextOnlyScrubber < ::Loofah::Scrubber
  def initialize; end

  def scrub(node); end
end

Rails::HTML::WhiteListSanitizer = Rails::HTML4::SafeListSanitizer
Rails::Html = Rails::HTML
