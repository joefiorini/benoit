require 'frontmatter'

module Staticly::Filters

  class ContentPageFilter < Rake::Pipeline::Filter

      def initialize
          super
          @page_layouts = {}
      end

      def generate_output(inputs, output)
          inputs.each do |input|

              layout = page_layouts_for_input(input).first
            # TODO: Only use this for files that don't extend already but have specified a layout, if the file extends, then just replace the extends line with the normalized layout
            template = <<-EOC
    {% extends '#{layout}' %}
  EOC
            FrontMatterStore.set_content_for_page! input.path, input.read

            output.write(template)

          end
      end

      def page_layouts_for_input(input)
          @page_layouts[input.path] ||=
              FindsLayoutsForTemplate(input.path, root: input.root, load_paths: ["_layouts"])
      end

      def additional_dependencies(input=nil)
          if input
             page_layouts_for_input(input)
          else
              []
          end
      end

  end
end
