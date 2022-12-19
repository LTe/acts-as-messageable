# typed: ignore

require_relative '../spec/spec_helper'

SorbetRails.configure { }

desc 'Generate types for model'
task :generate_rbi_for_model do
  establish_connection
  create_database

  formatter = SorbetRails::ModelRbiFormatter.new(ActsAsMessageable::Message, Set.new(['ActsAsMessageable::Message']))
  file_path = File.expand_path('../sorbet/rbi/models/acts-as-messageable/message.rbi', __dir__)
  FileUtils.mkdir_p(File.dirname(file_path))
  File.write(file_path, formatter.generate_rbi)

  drop_database
end
