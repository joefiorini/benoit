module Staticly::Filters
  class FrontMatterFilter < Rake::Pipeline::Filter

    include Staticly

    def generate_output(inputs, output)
      inputs.each do |input|

          front_matter =
          if FrontMatterParser.should_parse? input.fullpath
            FrontMatterParser.parse input.read
          else
            { 'content' => input.read }
          end

        filters_to_check = pipeline.filters - [self]

        final_output = super_pipeline.output_files.detect do |output|
            output.original_inputs == input.original_inputs
        end

        front_matter["_original_path"] = input.path

        FrontMatterStore.save final_output.path, front_matter

        output.write front_matter['content']
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
