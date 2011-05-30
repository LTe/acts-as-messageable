require "active_record"
require 'acts-as-messageable/message'
require 'acts-as-messageable/acts-as-messageable'
require 'acts-as-messageable/relation'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, ActsAsMessageable::Model
end

if defined?(ActiveRecord::Relation)
  ActiveRecord::Relation.send :include, ActsAsMessageable::Relation
end
