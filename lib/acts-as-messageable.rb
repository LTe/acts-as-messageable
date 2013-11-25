module ActsAsMessageable
  autoload :Model,    'acts-as-messageable/model'
  autoload :Scopes,   'acts-as-messageable/scopes'
  autoload :Message,  'acts-as-messageable/message'
  autoload :Relation, 'acts-as-messageable/relation'
  autoload :Rails3,   'acts-as-messageable/rails3'
  autoload :Rails4,   'acts-as-messageable/rails4'

  def self.rails_api
    if Rails::VERSION::MAJOR >= 4
      Rails4
    else
      Rails3
    end
  end
end

require 'acts-as-messageable/railtie'
