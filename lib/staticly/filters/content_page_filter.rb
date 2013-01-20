module Staticly::Filters

  class ContentPageFilter < Rake::Pipeline::Filter

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
             output = input.original_inputs.first.final_output
             page_layouts_for_input(output)
          else
              []
          end
      end

  end
end
