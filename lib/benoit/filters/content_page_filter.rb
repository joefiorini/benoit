module Benoit::Filters

  class ContentPageFilter < Rake::Pipeline::Filter

    attr_accessor :current_site

      def initialize
          super
          @page_layouts = {}
      end

      def generate_output(inputs, output)
          inputs.each do |input|

              layout = page_layouts_for_input(input).first

              template =
                if layout
              # TODO: Only use this for files that don't extend already but have specified a layout, if the file extends, then just replace the extends line with the normalized layout
                  "{% extends '#{layout}' %}\n\n"
                end.to_s

            template << input.read

            output.write(template)

          end
      end

      def page_layouts_for_input(input)
          @page_layouts[input.path] ||=
              FindsLayoutsForTemplate(input, root: input.root, load_paths: ["_layouts"])
      end

      def additional_dependencies(input=nil)
          if input
             output = current_site.paths_map[input.path]
             page_layouts_for_input(input)
          else
              []
          end
      end

  end
end
