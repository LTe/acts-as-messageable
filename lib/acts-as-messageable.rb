require "active_record"
require 'acts-as-messageable/acts-as-messageable'

module ActsAsMessageable
  autoload :Message, "acts-as-messageable/message"
  autoload :Relation, "acts-as-messageable/relation"
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, ActsAsMessageable::Model
end

if defined?(ActiveRecord::Relation)
  ActiveRecord::Relation.send :include, ActsAsMessageable::Relation
end
