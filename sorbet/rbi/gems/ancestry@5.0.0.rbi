# typed: true

# NOTE: This file was manually created due to a tapioca 0.17.10 limitation.
# When running `bin/tapioca gem ancestry`, tapioca generates an empty RBI file
# with "(empty output)" despite all Ancestry modules and methods being properly loaded.
#
# This appears to be a bug in tapioca 0.17.10 (from main@9be2a7bc3c61) as:
# - Ancestry 4.3.3 generated properly with the same gem structure
# - All Ancestry modules (ClassMethods, InstanceMethods, MaterializedPath, etc.) are present
# - Ancestry.singleton_methods and Ancestry.constants return expected values
#
# Until tapioca is fixed, this file provides type signatures for the `ancestry` gem.
# To regenerate once fixed: bin/tapioca gem ancestry


module Ancestry
  class << self
    def default_ancestry_format; end
    def default_ancestry_format=(value); end
    def default_primary_key_format; end
    def default_primary_key_format=(value); end
    def default_update_strategy; end
    def default_update_strategy=(value); end
  end
end

class Ancestry::AncestryException < ::RuntimeError; end
class Ancestry::AncestryIntegrityException < ::Ancestry::AncestryException; end

module Ancestry::ClassMethods
  def arrange(options = T.unsafe(nil)); end
  def arrange_nodes(nodes); end
  def arrange_serializable(options = T.unsafe(nil), nodes = T.unsafe(nil), &block); end
  def build_ancestry_from_parent_ids!(column = T.unsafe(nil), parent_id = T.unsafe(nil), ancestor_ids = T.unsafe(nil)); end
  def check_ancestry_integrity!(options = T.unsafe(nil)); end
  def flatten_arranged_nodes(arranged, nodes = T.unsafe(nil)); end
  def primary_key_is_an_integer?; end
  def rebuild_counter_cache!; end
  def rebuild_depth_cache!; end
  def rebuild_depth_cache_sql!; end
  def restore_ancestry_integrity!; end
  def scope_depth(depth_options, depth); end
  def sort_by_ancestry(nodes, &block); end
  def to_node(object); end
  def tree_view(column, data = T.unsafe(nil)); end
  def unscoped_where; end
end

module Ancestry::HasAncestry
  def acts_as_tree(*args); end
  def has_ancestry(options = T.unsafe(nil)); end
end

module Ancestry::InstanceMethods
  def ancestor_of?(node); end
  def ancestors(depth_options = T.unsafe(nil)); end
  def ancestors?; end
  def ancestry_callbacks_disabled?; end
  def ancestry_changed?; end
  def ancestry_exclude_self; end
  def apply_orphan_strategy_adopt; end
  def apply_orphan_strategy_destroy; end
  def apply_orphan_strategy_restrict; end
  def apply_orphan_strategy_rootify; end
  def cache_depth; end
  def child_ids; end
  def child_of?(node); end
  def childless?; end
  def children; end
  def children?; end
  def decrease_parent_counter_cache; end
  def depth; end
  def descendant_ids(depth_options = T.unsafe(nil)); end
  def descendant_of?(node); end
  def descendants(depth_options = T.unsafe(nil)); end
  def has_children?; end
  def has_parent?; end
  def has_siblings?; end
  def in_subtree_of?(node); end
  def increase_parent_counter_cache; end
  def indirect_ids(depth_options = T.unsafe(nil)); end
  def indirect_of?(node); end
  def indirects(depth_options = T.unsafe(nil)); end
  def is_childless?; end
  def is_only_child?; end
  def is_root?; end
  def only_child?; end
  def parent; end
  def parent=(parent); end
  def parent_id; end
  def parent_id=(new_parent_id); end
  def parent_id?; end
  def parent_of?(node); end
  def path(depth_options = T.unsafe(nil)); end
  def path_ids; end
  def path_ids_before_last_save; end
  def path_ids_in_database; end
  def root; end
  def root?; end
  def root_id; end
  def root_of?(node); end
  def sane_ancestor_ids?; end
  def sibling_ids; end
  def sibling_of?(node); end
  def siblings; end
  def siblings?; end
  def subtree(depth_options = T.unsafe(nil)); end
  def subtree_ids(depth_options = T.unsafe(nil)); end
  def touch_ancestors_callback; end
  def update_descendants_with_new_ancestry; end
  def update_parent_counter_cache; end
  def without_ancestry_callbacks; end

  private

  def unscoped_current_and_previous_ancestors; end
  def unscoped_descendants; end
  def unscoped_descendants_before_save; end
  def unscoped_find(id); end
  def unscoped_where; end
end

module Ancestry::MaterializedPath
  def ancestors_of(object); end
  def ancestry_depth_change(object); end
  def ancestry_depth_sql(depth_options); end
  def ancestry_root; end
  def child_ancestry_sql(object); end
  def children_of(object); end
  def concat(prefix, suffix); end
  def descendant_before_last_save_conditions(object); end
  def descendant_conditions(object); end
  def descendants_by_ancestry(ancestry); end
  def descendants_of(object); end
  def generate_ancestry(ancestor_ids); end
  def indirects_of(object); end
  def inpath_of(object); end
  def ordered_by_ancestry(order = T.unsafe(nil)); end
  def ordered_by_ancestry_and(order); end
  def parse_ancestry_column(obj); end
  def path_of(object); end
  def roots; end
  def siblings_of(object); end
  def subtree_of(object); end

  private

  def ancestry_format_regexp; end
  def ancestry_nil_allowed?; end
  def ancestry_validation_options; end

  class << self
    def extended(base); end
  end
end

module Ancestry::MaterializedPath2
  include ::Ancestry::MaterializedPath

  def ancestry_depth_sql(depth_options); end
  def ancestry_root; end
  def child_ancestry_sql(object); end
  def descendants_by_ancestry(ancestry); end
  def generate_ancestry(ancestor_ids); end
  def indirects_of(object); end
  def ordered_by_ancestry(order = T.unsafe(nil)); end

  private

  def ancestry_format_regexp; end
  def ancestry_nil_allowed?; end

  class << self
    def extended(base); end
  end
end

module Ancestry::MaterializedPath2::InstanceMethods
  def child_ancestry; end
  def child_ancestry_before_last_save; end
  def generate_ancestry(ancestor_ids); end
end

module Ancestry::MaterializedPath::InstanceMethods
  def ancestor_ids; end
  def ancestor_ids=(value); end
  def ancestor_ids_before_last_save; end
  def ancestor_ids_in_database; end
  def ancestors?; end
  def child_ancestry; end
  def child_ancestry_before_last_save; end
  def generate_ancestry(ancestor_ids); end
  def has_parent?; end
  def parent_id_before_last_save; end
  def parent_id_in_database; end
  def parse_ancestry_column(obj); end
  def sibling_of?(node); end
end

module Ancestry::MaterializedPathPg
  def update_descendants_with_new_ancestry; end
end

Ancestry::VERSION = T.let(T.unsafe(nil), String)
