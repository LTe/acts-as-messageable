# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: ignore
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/actionview/all/actionview.rbi
#
# actionview-7.0.1

module ActionView
  def self.eager_load!; end
  def self.gem_version; end
  def self.version; end
  extend ActiveSupport::Autoload
end
module ActionView::VERSION
end
class ActionView::Railtie < Rails::Engine
end
module ActionView::ViewPaths
  def _prefixes; end
  def any_templates?(**, &&); end
  def append_view_path(path); end
  def details_for_lookup; end
  def formats(**, &&); end
  def formats=(arg); end
  def locale(**, &&); end
  def locale=(arg); end
  def lookup_context; end
  def prepend_view_path(path); end
  def self.all_view_paths; end
  def self.get_view_paths(klass); end
  def self.set_view_paths(klass, paths); end
  def template_exists?(**, &&); end
  def view_paths(**, &&); end
  extend ActiveSupport::Concern
end
module ActionView::ViewPaths::ClassMethods
  def _prefixes; end
  def _view_paths; end
  def _view_paths=(paths); end
  def append_view_path(path); end
  def local_prefixes; end
  def prepend_view_path(path); end
  def view_paths; end
  def view_paths=(paths); end
end
class ActionView::I18nProxy < I18n::Config
  def initialize(original_config, lookup_context); end
  def locale; end
  def locale=(value); end
  def lookup_context; end
  def original_config; end
end
module ActionView::Rendering
  def _normalize_args(action = nil, options = nil); end
  def _normalize_options(options); end
  def _process_format(format); end
  def _render_template(options); end
  def initialize; end
  def process(*arg0); end
  def render_to_body(options = nil); end
  def rendered_format; end
  def view_context; end
  def view_context_class; end
  def view_renderer; end
  extend ActiveSupport::Concern
  include ActionView::ViewPaths
end
module ActionView::Rendering::ClassMethods
  def _helpers; end
  def _routes; end
  def build_view_context_class(klass, supports_path, routes, helpers); end
  def view_context_class; end
end
module ActionView::Layouts
  def _conditional_layout?; end
  def _default_layout(lookup_context, formats, require_layout = nil); end
  def _include_layout?(options); end
  def _layout(*arg0); end
  def _layout_conditions(**, &&); end
  def _layout_for_option(name); end
  def _normalize_layout(value); end
  def _normalize_options(options); end
  def action_has_layout=(arg0); end
  def action_has_layout?; end
  def initialize(*arg0); end
  extend ActiveSupport::Concern
  include ActionView::Rendering
end
module ActionView::Layouts::ClassMethods
  def _implied_layout_name; end
  def _write_layout_method; end
  def inherited(klass); end
  def layout(layout, conditions = nil); end
end
module ActionView::Layouts::ClassMethods::LayoutConditions
  def _conditional_layout?; end
end
class ActionView::PathSet
  def +(array); end
  def <<(*args); end
  def [](**, &&); end
  def compact; end
  def concat(*args); end
  def each(**, &&); end
  def exists?(path, prefixes, partial, details, details_key, locals); end
  def find(path, prefixes, partial, details, details_key, locals); end
  def find_all(path, prefixes, partial, details, details_key, locals); end
  def include?(**, &&); end
  def initialize(paths = nil); end
  def initialize_copy(other); end
  def insert(*args); end
  def paths; end
  def pop(**, &&); end
  def push(*args); end
  def search_combinations(prefixes); end
  def size(**, &&); end
  def to_ary; end
  def typecast(paths); end
  def unshift(*args); end
  include Enumerable
end
