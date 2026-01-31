# typed: true
# frozen_string_literal: true

require 'kramdown'

# A custom Kramdown converter that generates a table of contents.
class TocConverter < Kramdown::Converter::Toc
  class << self
    def convert(doc, options)
      result, = super(doc.root, options)
      convert_to_list_items(result.children)
    end

    def convert_to_list_items(elements)
      elements.flat_map do |elem|
        level = elem.value.options[:level]
        text = elem.value.options[:raw_text]
        id = elem.attr[:id]
        padding = '  ' * (level - 1)

        ["#{padding}* [#{text}](##{id})"] + convert_to_list_items(elem.children)
      end
    end
  end

  def in_toc?(element)
    super && element.options[:raw_text] !~ /<!--\sno_toc\s-->/
  end
end

desc('Updates the README file')
task :readme do # rubocop:disable Metrics/BlockLength
  assert_synchronized = lambda do |path|
    # Do not print diff and yield whether exit code was zero
    sh("test -z \"$(git status --porcelain #{path})\"") do |outcome, _|
      return if outcome

      # Output diff before raising error
      sh("git status --porcelain #{path}")

      warn(<<~WARNING)
        The `#{path}` is out of sync.
        Run `bundle exec rake readme` and commit the results.
      WARNING

      exit!
    end
  end

  replace_section = lambda do |contents, section_name, replacement|
    contents.sub(
      /(<!-- START_#{section_name} -->).+(<!-- END_#{section_name} -->)/m, <<~OUT.chomp
        \\1
        #{replacement.chomp}
        \\2
      OUT
    )
  end

  print_toc = lambda do |contents|
    section = 'TOC'

    doc = Kramdown::Document.new(contents)
    toc = TocConverter.convert(doc, { auto_id: true, toc_levels: (1..6) })

    replace_section.call(contents, section, toc.join("\n"))
  end

  path = "#{Dir.pwd}/README.md"

  contents = File.read(path)
  contents = print_toc.call(contents)
  File.write(path, contents)

  assert_synchronized.call(path)
end
