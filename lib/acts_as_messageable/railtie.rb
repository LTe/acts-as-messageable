# typed: false
# frozen_string_literal: true

require 'active_record/railtie'

module ActsAsMessageable
  class Railtie < Rails::Railtie
    ActiveRecord::Base.include ActsAsMessageable::Model if defined?(ActiveRecord::Base)

    ActiveRecord::Relation.include ActsAsMessageable::Relation if defined?(ActiveRecord::Relation)

    # Mongoid support
    initializer 'acts_as_messageable.mongoid' do
      if defined?(::Mongoid::Document)
        require 'acts_as_messageable/mongoid'

        ::Mongoid::Document::ClassMethods.include ActsAsMessageable::Mongoid::Model

        ::Mongoid::Criteria.include ActsAsMessageable::Mongoid::Relation
      end
    end
  end
end
