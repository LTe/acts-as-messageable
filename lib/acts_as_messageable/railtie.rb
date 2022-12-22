# typed: strict
# frozen_string_literal: true

require 'active_record/railtie'

module ActsAsMessageable
  class Railtie < Rails::Railtie
    ActiveRecord::Base.include ActsAsMessageable::Model if defined?(ActiveRecord::Base)

    ActiveRecord::Relation.include ActsAsMessageable::Relation if defined?(ActiveRecord::Relation)
  end
end
