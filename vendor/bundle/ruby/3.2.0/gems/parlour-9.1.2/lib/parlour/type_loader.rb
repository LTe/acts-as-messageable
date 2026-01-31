# typed: true

require 'open3'
require 'json'

module Parlour
  module TypeLoader
    extend T::Sig

    # TODO: make this into a class which stores configuration and passes it to
    # all typeparsers

    sig { params(source: String, filename: T.nilable(String), generator: T.nilable(RbiGenerator)).returns(RbiGenerator::Namespace) }
    # Converts Ruby source code into a tree of objects.
    #
    # @param [String] source The Ruby source code.
    # @param [String, nil] filename The filename to use when parsing this code.
    #   This may be used in error messages, but is optional.
    # @return [RbiGenerator::Namespace] The root of the object tree.
    def self.load_source(source, filename = nil, generator: nil)
      TypeParser.from_source(filename || '(source)', source, generator: generator).parse_all
    end

    sig { params(filename: String, generator: T.nilable(RbiGenerator)).returns(RbiGenerator::Namespace) }
    # Converts Ruby source code into a tree of objects from a file.
    #
    # @param [String] filename The name of the file to load code from.
    # @return [RbiGenerator::Namespace] The root of the object tree.
    def self.load_file(filename, generator: nil)
      load_source(File.read(filename), filename, generator: generator)
    end

    sig do
      params(
        root: String,
        inclusions: T::Array[String],
        exclusions: T::Array[String],
        generator: T.nilable(RbiGenerator),
      ).returns(RbiGenerator::Namespace)
    end
    # Loads an entire Sorbet project using Sorbet's file table, obeying any
    # "typed: ignore" sigils, into a tree of objects.
    #
    # Files within sorbet/rbi/hidden-definitions are excluded, as they cause
    # merging issues with abstract classes due to sorbet/sorbet#1653.
    #
    # @param [String] root The root of the project; where the "sorbet" directory
    #   and "Gemfile" are located.
    # @param [Array<String>] inclusions A list of files to include when loading
    #   the project, relative to the given root.
    # @param [Array<String>] exclusions A list of files to exclude when loading
    #   the project, relative to the given root.
    # @return [RbiGenerator::Namespace] The root of the object tree.
    def self.load_project(root, inclusions: ['.'], exclusions: [], generator: nil)
      expanded_inclusions = inclusions.map { |i| File.expand_path(i, root) }
      expanded_exclusions = exclusions.map { |e| File.expand_path(e, root) }

      cmd = 'bundle exec srb tc -p file-table-json'
      stdout, _stderr, io_status = T.unsafe(Open3).capture3(
        cmd,
        chdir: root
      )

      # ignore output code, which may indicate type checking issues
      # that aren't blocking us
      if stdout == ''
        raise "unable to get Sorbet file table with #{cmd.inspect}; " \
              'the project may be empty or not have Sorbet initialised'
      end

      file_table_hash = JSON.parse(stdout)
      file_table_entries = file_table_hash['files']

      namespaces = T.let([], T::Array[Parlour::RbiGenerator::Namespace])
      file_table_entries.each do |file_table_entry|
        next if file_table_entry['sigil'] == 'Ignore' ||
          file_table_entry['strict'] == 'Ignore'

        rel_path = file_table_entry['path']
        next if rel_path.start_with?('./sorbet/rbi/hidden-definitions/')
        path = File.expand_path(rel_path, root)

        # Skip this file if it was excluded
        next if !expanded_inclusions.any? { |i| path.start_with?(i) } \
          || expanded_exclusions.any? { |e| path.start_with?(e) }

        # There are some entries which are URLs to stdlib
        next unless File.exist?(path)

        namespaces << load_file(path, generator: generator)
      end

      namespaces.uniq!

      raise 'project is empty' if namespaces.empty?

      first_namespace, *other_namespaces = namespaces
      first_namespace = T.must(first_namespace)
      other_namespaces = T.must(other_namespaces)

      raise 'cannot merge namespaces loaded from a project' \
        unless first_namespace.mergeable?(other_namespaces)
      first_namespace.merge_into_self(other_namespaces)

      ConflictResolver.new.resolve_conflicts(first_namespace) do |n, o|
        raise "conflict of #{o.length} objects: #{n}"
      end

      first_namespace
    end
  end
end
