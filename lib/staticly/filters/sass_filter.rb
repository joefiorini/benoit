#
#  sass_filter.rb
#  Staticly
#
#  Created by Joseph Fiorini on 10/6/12.
#  Copyright 2012 densitypop. All rights reserved.
#

require 'compass'
require 'sass'

class Staticly::Filters::SassFilter < Rake::Pipeline::Filter
    attr_reader :options, :additional_load_paths

    def initialize(options={})
        # TODO: Handle files that don't end in .scss
        block ||= proc { |input| input.sub(/\.(scss|sass)$/, '') }
        super(&block)
        Compass.add_project_configuration
        Compass.configuration.project_path ||= Dir.pwd
        @additional_load_paths = Compass.configuration.sass_load_paths
        @additional_load_paths += options.delete(:additional_load_paths).map do |f|
            File.expand_path(f)
        end


        @options = options
        @options[:load_paths] ||= []
        @options[:load_paths].concat(additional_load_paths)

    end

    def generate_output(inputs, output)
      inputs.each do |input|
        begin
          sass_options = sass_options_for_file(input).merge(filename: input.path)
          sass_engine = Sass::Engine.for_file(input.path, sass_options)
          output.write sass_engine.render
        rescue Sass::SyntaxError => ex
          path = ex.sass_filename.gsub(input.root + "/", "")
          missing_files = ex.message.scan(/File to import not found or unreadable: ([\w\-]*)\./).flatten
          if missing_files.empty?
            error = Staticly::CompilerError.new(nil, path, ex)
            error.line = ex.sass_line
          else
            error = Staticly::FileMissingError.new(missing_files.first, ex.sass_line, path, ex)
          end
          raise error
        rescue StandardError => ex
          raise Staticly::CompilerError.new(nil, path, ex)
        end
      end
    end

    def additional_dependencies(input=nil)
        Dir.glob("**/*.scss")
    end


    private

    def sass_options_for_file(file)
        added_opts = {
            :syntax => file.path.match(/\.sass$/) ? :sass : :scss,
            :trace => true,
            :cache => false,
            :cache_location => nil
        }

        added_opts.merge(@options)
    end
end
