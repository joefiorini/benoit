require 'cadenza'

class Staticly::Filters::CadenzaFilter < Rake::Pipeline::Filter
    attr_reader :options

    def initialize
        super
        @page_layouts = {}
    end

    def generate_output(inputs, output)

        context = SiteContext.from_hash(FrontMatterStore)

        inputs.each do |input|
            load_paths = [input.root, Dir.pwd, "#{Dir.pwd}/_layouts"]

            FrontMatterStore.set_metadata_for_page input.path, "permalink" => "/#{output.path}"

            load_paths.each do |load_path|
              Cadenza::BaseContext.add_load_path load_path
            end

            context_hash = {
                "site" => context,
                "page" => PageContext.from_hash(FrontMatterStore[input.path] || {})
            }

            begin
              compiled = Cadenza.render_template input.path, JSON.parse(context_hash.to_json)
            rescue Cadenza::TemplateNotFoundError => ex
              error = Staticly::FileMissingError.new(ex.message, nil, input.path, ex)
              raise error
            rescue Cadenza::FilterNotDefinedError => ex
              missing_filter = ex.message.scan(/undefined: '([\w\-_]*)'/).flatten.first
              error = Staticly::CompilerError.new(nil, input.path, ex)
              error.message = "You used a filter named #{missing_filter.inspect}, but I could not find it. Maybe it's misspelled?"
              raise error
            rescue Cadenza::Error => ex
            end

            output.write compiled
        end
    end


      def page_layouts_for_input(input)
          @page_layouts[input.path] ||=
              FindsLayoutsForTemplate(input.path, root: input.root, load_paths: ["_layouts"])
      end

      def additional_dependencies(input=nil)
          if input
              Dir["**/*.markdown"].map do |f|
                  f.gsub input.root, ""
              end
          else
              []
          end
      end

end
