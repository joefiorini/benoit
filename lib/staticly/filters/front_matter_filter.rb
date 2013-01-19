module Staticly::Filters
  class MetadataCleaner < Rake::Pipeline::Filter

    include Staticly

    def generate_output(inputs, output)
      inputs.each do |input|


        key = input.original_inputs.first.final_output
        if key
          metadata = Staticly::PageMetadata::Store.current[key]
          if metadata.key?("content")
            output.write metadata["content"]
          else
            output.write input.read
          end
        end
      end
    end


    def super_pipeline(descendent=self.pipeline)
        if descendent.respond_to? :pipeline
            super_pipeline(descendent.pipeline)
        else
            descendent
        end
    end


  end
end
