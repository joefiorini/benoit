#
#  CompilerError.rb
#  Staticly
#
#  Created by Joseph Fiorini on 11/5/12.
#  Copyright 2012 densitypop. All rights reserved.
#


module Staticly
    class CompilerError < StandardError
        attr_accessor :line, :message
        attr_reader :output, :env, :file_path

        def initialize(line, file_path, original_error)
            @line = line
            @file_path = file_path
            @output = output
            @env = env
        end

    end

    class FileMissingError < CompilerError
      attr_accessor :missing_file

      def initialize(missing_file, line, file_path, original_error)
        @missing_file = missing_file
        super line, file_path, original_error
      end

      def message
<<-EOS
You included a file named #{missing_file.inspect} in #{file_path.inspect}. I could not find a file with that name. Maybe you forgot to specify a folder?
EOS
      end

    end
end