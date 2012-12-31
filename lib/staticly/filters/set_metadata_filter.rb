module Staticly::Filters
  class SetMetadataFilter < Rake::Pipeline::Filter
      def initialize(metadata={}, &block)
          @metadata = metadata
          super &block
      end

      def generate_output(inputs, output)
          inputs.each do |input|
              FrontMatterStore.set_metadata_for_page input.path, @metadata
              output.write(input.read)
          end
      end
  end
end
