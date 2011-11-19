require 'active_record/railtie'
require 'active_support/core_ext'

module ActsAsMessageable
  class Railtie < Rails::Railtie
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.send :include, ActsAsMessageable::Model
    end

    if defined?(ActiveRecord::Relation)
      ActiveRecord::Relation.send :include, ActsAsMessageable::Relation
    end
  end
end
