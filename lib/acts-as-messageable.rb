require "active_record"

#$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'acts-as-messageable/acts-as-messageable'
require 'acts-as-messageable/message'

#$LOAD_PATH.shift

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, ActsAsMessageable::Model
end
