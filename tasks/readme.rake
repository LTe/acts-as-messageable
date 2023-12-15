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
task :readme do
  def replace_section(contents, section_name, replacement)
    contents.sub(
      /(<!-- START_#{section_name} -->).+(<!-- END_#{section_name} -->)/m, <<~OUT.chomp
        \\1
        #{replacement.chomp}
        \\2
      OUT
    )
  end

  def print_toc(contents)
    section = 'TOC'

    doc = Kramdown::Document.new(contents)
    toc = TocConverter.convert(doc, { auto_id: true, toc_levels: (1..6) })

    replace_section(contents, section, toc.join("\n"))
  end

  path = "#{Dir.pwd}/README.md"

  contents = File.read(path)
  contents = print_toc(contents)
  File.write(path, contents)
end
