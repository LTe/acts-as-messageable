require "active_record"

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'acts_as_messageable/acts-as-messageable'
require 'acts_as_messageable/message'

$LOAD_PATH.shift

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, ActsAsMessageable::User
end
