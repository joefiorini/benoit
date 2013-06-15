require 'cadenza'

class Benoit::Filters::CadenzaFilter < Rake::Pipeline::Filter
    attr_reader :options
    attr_accessor :current_site

    include Benoit

    def initialize
      super
      @page_layouts = {}
    end

    def generate_output(inputs, output)

      # site_context = current_site.to_context

        inputs.each do |input|
            load_paths = [input.root, Dir.pwd, "#{Dir.pwd}/_layouts"]

            Benoit::Cadenza.load_output_filters!

            load_paths.each do |load_path|
              ::Cadenza::BaseContext.add_load_path load_path
            end

            # page = current_site[input.path].to_hash

            # Leave the original page for paginated pages blank
            #  otherwise we will get an "iteration reached an end" error
            #  from trying to iterate past the end of the enumerator
            # if input.path !~ /\d+.html/ && page.keys.any? { |key| key =~ /\w+_per_page/ }
            #   output.write("")
            #   next
            # end

            # context_hash = {
            #     "site" => site_context,
            #     "page" => page
            # }
            context_hash = {}

            begin
              compiled = ::Cadenza.render_template input.path, context_hash
            rescue ::Cadenza::TemplateNotFoundError => ex
              error = Benoit::FileMissingError.new(ex.message, nil, input.path, ex)
              raise error
            rescue ::Cadenza::FilterNotDefinedError => ex
              missing_filter = ex.to_s.scan(/undefined filter '([\w\-]*)'/).flatten.first
              error = Benoit::CompilerError.new(nil, input.path, ex)
              error.message = "You used a filter named #{missing_filter.inspect}, but I could not find it. Maybe it's misspelled?"
              raise error
            rescue ::Cadenza::BlockNotDefinedError => ex
              missing_block = ex.to_s.scan(/undefined block '([\w\-]*)'/).flatten.first
              error = Benoit::CompilerError.new(nil, input.path, ex)
              error.message = "You used a block named #{missing_block.inspect}, but I could not find it. Maybe it's misspelled?"
              raise error
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
