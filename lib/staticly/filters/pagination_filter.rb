module Staticly
  module Filters
    class PaginationFilter < Rake::Pipeline::Filter

      def generate_output(inputs, output)
        inputs.each do |input|
          output.write input.read
        end
      end
    end
  end
end
