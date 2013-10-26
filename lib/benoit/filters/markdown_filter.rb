require 'kramdown'
require 'benoit/utils/finds_layouts_for_template'

module Benoit::Filters
  class MarkdownFilter < BaseFilter

    output_name do |path|
      path.sub(/\.(md|mdown|mkdown|markdown)$/, '.html')
    end

    build_output do |input|
      input_content = input.read
      layout = Benoit::Utils::FindsLayoutsForTemplate.first_layout(input_content)
      preserving_layout(layout, input_content) do |content|
        render_markdown(:kramdown, content)
      end
    end

    def self.preserving_layout(layout, content, &block)
      content = extract_layout(content) if layout
      output = block.call(content)
      output = prepend_layout(output, layout) if layout
      output
    end

    def self.extract_layout(content)
      first_nonblank_line =
        content.lines.find_index do |line|
          line !~ /extends/ and line.strip != ""
        end
      content.lines.to_a[first_nonblank_line..-1].join("")
    end

    def self.prepend_layout(final_content, layout)
      extends_line = %{{% extends "#{layout}" %}\n\n}
      %{#{extends_line}#{final_content}}
    end

    def self.render_markdown(engine, content, options={})
      case engine
      when :redcarpet
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true, filter_html: true)
        markdown.render(content)
      when :kramdown
        Kramdown::Document.new(content).to_html
      end
    end

  end
end
