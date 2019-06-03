require 'active_record/railtie'

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
