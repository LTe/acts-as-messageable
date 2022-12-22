# typed: ignore

require_relative '../spec/spec_helper'
require 'active_support/core_ext/string'
require 'sorbet-rails'
require 'sorbet-rails/active_record_rbi_formatter'

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

def generate_types_for_active_record_runtime
  establish_connection
  create_database

  dir_path = File.expand_path("../sorbet/rbi/rails-rbi/", __dir__)
  FileUtils.mkdir_p(dir_path)

  formatter = SorbetRails::ActiveRecordRbiFormatter.new

  file_path = File.expand_path("../sorbet/rbi/rails-rbi/active_record_base.rbi", __dir__)
  File.write(file_path, formatter.generate_active_record_base_rbi)

  file_path = File.expand_path("../sorbet/rbi/rails-rbi/active_record_relation.rbi", __dir__)
  File.write(file_path, formatter.generate_active_record_relation_rbi)

  drop_database
end

desc 'Generate types for model'
task :generate_rbi_for_model do
  generate_type(ActsAsMessageable::Message, 'ActsAsMessageable::Message', 'message')
  generate_type(CustomSearchUser, 'CustomSearchUser', 'user')
  generate_types_for_active_record_runtime
end
