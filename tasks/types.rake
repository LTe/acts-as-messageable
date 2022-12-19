# typed: ignore

require_relative '../spec/spec_helper'
require 'sorbet-rails'

SorbetRails.configure { }

def generate_type(model, model_name, file_name)
  establish_connection
  create_database

  formatter = SorbetRails::ModelRbiFormatter.new(model, Set.new([model_name]))
  file_path = File.expand_path("../sorbet/rbi/models/acts-as-messageable/#{file_name}.rbi", __dir__)
  FileUtils.mkdir_p(File.dirname(file_path))
  File.write(file_path, formatter.generate_rbi)

  drop_database
end

desc 'Generate types for model'
task :generate_rbi_for_model do
  generate_type(ActsAsMessageable::Message, 'ActsAsMessageable::Message', 'message')
  generate_type(CustomSearchUser, 'CustomSearchUser', 'user')
end
