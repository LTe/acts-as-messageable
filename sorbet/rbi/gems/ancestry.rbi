# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/ancestry/all/ancestry.rbi
#
# ancestry-4.1.0

module Ancestry
  def self.default_update_strategy; end
  def self.default_update_strategy=(value); end
end
module Ancestry::ClassMethods
  def arrange(options = nil); end
  def arrange_nodes(nodes); end
  def arrange_serializable(options = nil, nodes = nil, &block); end
  def build_ancestry_from_parent_ids!(column = nil, parent_id = nil, ancestor_ids = nil); end
  def check_ancestry_integrity!(options = nil); end
  def orphan_strategy=(orphan_strategy); end
  def primary_key_is_an_integer?; end
  def rebuild_depth_cache!; end
  def restore_ancestry_integrity!; end
  def scope_depth(depth_options, depth); end
  def sort_by_ancestry(nodes, &block); end
  def to_node(object); end
  def unscoped_where; end
end
module Ancestry::InstanceMethods
  def _counter_cache_column; end
  def ancestor_of?(node); end
  def ancestors(depth_options = nil); end
  def ancestors?; end
  def ancestry_callbacks_disabled?; end
  def ancestry_changed?; end
  def ancestry_exclude_self; end
  def apply_orphan_strategy; end
  def cache_depth; end
  def child_ids; end
  def child_of?(node); end
  def childless?; end
  def children; end
  def children?; end
  def decrease_parent_counter_cache; end
  def depth; end
  def descendant_ids(depth_options = nil); end
  def descendant_of?(node); end
  def descendants(depth_options = nil); end
  def has_children?; end
  def has_parent?; end
  def has_siblings?; end
  def increase_parent_counter_cache; end
  def indirect_ids(depth_options = nil); end
  def indirect_of?(node); end
  def indirects(depth_options = nil); end
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
  def path(depth_options = nil); end
  def path_ids; end
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
  def subtree(depth_options = nil); end
  def subtree_ids(depth_options = nil); end
  def touch_ancestors_callback; end
  def unscoped_current_and_previous_ancestors; end
  def unscoped_descendants; end
  def unscoped_find(id); end
  def unscoped_where; end
  def update_descendants_with_new_ancestry; end
  def update_parent_counter_cache; end
  def without_ancestry_callbacks; end
end
class Ancestry::AncestryException < RuntimeError
end
class Ancestry::AncestryIntegrityException < Ancestry::AncestryException
end
module Ancestry::HasAncestry
  def acts_as_tree(*args); end
  def derive_ancestry_pattern(primary_key_format, delimiter = nil); end
  def has_ancestry(options = nil); end
end
module Ancestry::MaterializedPath
  def ancestors_of(object); end
  def children_of(object); end
  def descendant_conditions(object); end
  def descendants_of(object); end
  def indirects_of(object); end
  def inpath_of(object); end
  def ordered_by_ancestry(order = nil); end
  def ordered_by_ancestry_and(order); end
  def path_of(object); end
  def roots; end
  def self.extended(base); end
  def siblings_of(object); end
  def subtree_of(object); end
end
module Ancestry::MaterializedPath::InstanceMethods
  def ancestor_ids; end
  def ancestor_ids=(value); end
  def ancestor_ids_before_last_save; end
  def ancestor_ids_in_database; end
  def ancestors?; end
  def child_ancestry; end
  def has_parent?; end
  def parent_id_before_last_save; end
  def parse_ancestry_column(obj); end
  def sibling_of?(node); end
end
module Ancestry::MaterializedPathPg
  def update_descendants_with_new_ancestry; end
end