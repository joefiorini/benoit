require 'redcarpet'

module Staticly::Filters
  class MarkdownFilter < BaseFilter

    output_name do |path|
      path.sub(/\.(md|mdown|mkdown|markdown)$/, '.html')
    end

    build_output do |page|

      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true)
      rendered = markdown.render(page["content"])

      page["content"] = rendered
    end

  end
end
