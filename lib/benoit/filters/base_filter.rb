module Benoit
  module Filters
    class BaseFilter < Rake::Pipeline::Filter

      class << self
        attr_reader :builder, :output_name_generator

        def build_output(&block)
          @builder = block
        end

        def output_name(&block)
          @output_name_generator = block
        end
      end

      attr_accessor :current_site

      def output_name_generator
        self.class.output_name_generator ||
          @output_name_generator
      end

      def builder
        self.class.builder
      end

      def generate_output(inputs, output)
        inputs.each do |input|
          page = current_site[input.path]
          content = build_output(page, input) if builder
          output.write(content || page["content"])
        end
      end

      private

      def build_output(page, input)
        builder.(page, input)
      end

    end
  end
end
