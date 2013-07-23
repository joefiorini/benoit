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
          content = build_output(input) if builder
          output.write(content || input.read)
        end
      end

      private

      def build_output(input)
        builder.(input)
      end

    end
  end
end
