module Staticly::Filters
  class MetadataCleaner < Rake::Pipeline::Filter

    include Staticly

    attr_accessor :current_site

    def generate_output(inputs, output)
      inputs.each do |input|
        metadata = current_site[input.path]
        if metadata and metadata.key?("content")
          output.write metadata["content"]
        else
          output.write input.read
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
