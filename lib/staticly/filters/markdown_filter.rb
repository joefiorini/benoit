require 'redcarpet'

module Staticly::Filters
  class MarkdownFilter < Rake::Pipeline::Filter

    def initialize(&block)
      block ||= proc { |input| input.sub(/\.(md|mdown|mkdown|markdown)$/, '.html') }
      super(&block)
    end

    def generate_output(inputs, output)
      inputs.each do |input|

        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true)
        template_content = markdown.render(input.read)


        key = input.original_inputs.first.final_output
        Staticly::PageMetadata::Store.current[key]["content"] = template_content

        output.write(template_content)

      end
    end

  end
end
