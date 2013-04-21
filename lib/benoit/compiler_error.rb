#
#  CompilerError.rb
#  Benoit
#
#  Created by Joseph Fiorini on 11/5/12.
#  Copyright 2012 densitypop. All rights reserved.
#

class StandardError
  def to_json
    { message: "Benoit has encountered an internal error. Please contact @benoitapp on Twitter to resolve this problem.", type: "error" }.to_json
  end
end

module Benoit
    class CompilerError < StandardError
        attr_accessor :line, :message
        attr_reader :output, :env, :file_path, :original_error

        def initialize(line, file_path, original_error)
            @line = line
            @file_path = file_path
            @output = output
            @env = env
            @original_error = original_error
        end

        def to_json
          { line_no: @line, message: @message, path: @file_path, original_error: @original_error, type: "error" }.to_json
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
