# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rails-dom-testing` gem.
# Please instead update this file by running `bin/tapioca gem rails-dom-testing`.

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

module Rails::Dom; end

module Rails::Dom::Testing
  def default_html_version; end
  def default_html_version=(val); end

  class << self
    def default_html_version; end
    def default_html_version=(val); end
    def html5_support?; end
    def html_document(html_version: T.unsafe(nil)); end
    def html_document_fragment(html_version: T.unsafe(nil)); end

    private

    def choose_html_parser(parser_classes, html_version: T.unsafe(nil)); end
  end
end

module Rails::Dom::Testing::Assertions
  include ::Rails::Dom::Testing::Assertions::DomAssertions
  include ::Rails::Dom::Testing::Assertions::SelectorAssertions
end

module Rails::Dom::Testing::Assertions::DomAssertions
  def assert_dom_equal(expected, actual, message = T.unsafe(nil), strict: T.unsafe(nil), html_version: T.unsafe(nil)); end
  def assert_dom_not_equal(expected, actual, message = T.unsafe(nil), strict: T.unsafe(nil), html_version: T.unsafe(nil)); end

  protected

  def compare_doms(expected, actual, strict); end
  def equal_attribute?(attr, other_attr); end
  def equal_attribute_nodes?(nodes, other_nodes); end
  def equal_child?(child, other_child, strict); end
  def equal_children?(child, other_child, strict); end
  def extract_children(node, strict); end

  private

  def fragment(text, html_version: T.unsafe(nil)); end
end

module Rails::Dom::Testing::Assertions::SelectorAssertions
  def assert_dom(*args, &block); end
  def assert_dom_email(html_version: T.unsafe(nil), &block); end
  def assert_dom_encoded(element = T.unsafe(nil), html_version: T.unsafe(nil), &block); end
  def assert_select(*args, &block); end
  def assert_select_email(html_version: T.unsafe(nil), &block); end
  def assert_select_encoded(element = T.unsafe(nil), html_version: T.unsafe(nil), &block); end
  def css_select(*args); end

  private

  def assert_size_match!(size, equals, css_selector, message = T.unsafe(nil)); end
  def count_description(min, max, count); end
  def document_root_element; end
  def nest_selection(selection); end
  def nodeset(node); end
  def pluralize_element(quantity); end
end

class Rails::Dom::Testing::Assertions::SelectorAssertions::HTMLSelector
  include ::Minitest::Assertions

  def initialize(values, previous_selection = T.unsafe(nil), &root_fallback); end

  def context; end
  def css_selector; end
  def message; end
  def select; end
  def selecting_no_body?; end
  def tests; end

  private

  def extract_equality_tests; end
  def extract_root(previous_selection, root_fallback); end
  def extract_selectors; end
  def filter(matches); end

  class << self
    def context; end
  end
end

Rails::Dom::Testing::Assertions::SelectorAssertions::HTMLSelector::NO_STRIP = T.let(T.unsafe(nil), Array)

class Rails::Dom::Testing::Assertions::SelectorAssertions::SubstitutionContext
  def initialize; end

  def match(matches, attribute, matcher); end
  def substitute!(selector, values, format_for_presentation = T.unsafe(nil)); end

  private

  def matcher_for(value, format_for_presentation); end
  def substitutable?(value); end
end

class Rails::Dom::Testing::Railtie < ::Rails::Railtie; end
