#
#  pass_thru_filter.rb
#  Benoit
#
#  Created by Joseph Fiorini on 10/3/12.
#  Copyright 2012 densitypop. All rights reserved.
#


module Benoit::Filters
    class PassThruFilter < Rake::Pipeline::Filter

        processes_binary_files

        def generate_output(inputs, output)
            inputs.each do |input|
                output.write input.read
            end
        end

    end
end
