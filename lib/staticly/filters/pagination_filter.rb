class Pathname
  def append_basename(str, suffix=nil)
    ext = suffix || extname
    n = basename(ext)
    Pathname.new(n.to_s + str.to_s + ext.to_s)
  end
end

module Staticly
  module Filters
    class PaginationFilter < Rake::Pipeline::Filter

      def initialize
        @output_name_generator = ->(_,input){
          pages_for_input = pipeline.per_page_counts[input]
          (1..pages_for_input).to_a.map do |page|
            Pathname.new(input.path).append_basename(page.to_s).to_path
          end
        }
      end

      def generate_output(inputs, output)
        inputs.each do |input|
          output.write input.read
        end
      end
    end
  end
end
