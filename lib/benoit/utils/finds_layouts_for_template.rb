#
#  TemplateLayoutLookup.rb
#  Benoit
#
#  Created by Joseph Fiorini on 10/29/12.
#  Copyright 2012 densitypop. All rights reserved.
#

def FindsLayoutsForTemplate(input, options={})
    Benoit::Utils::FindsLayoutsForTemplate.new(input, options).lookup_layouts
end

module Benoit::Utils


    class FindsLayoutsForTemplate


        attr_reader :root, :template_path, :load_paths, :input

        def self.first_layout(content, options={})
          FindsLayoutsForTemplate.new(content, options).lookup_layout
        end

        def initialize(input, options)
          if input.respond_to? :path
            @input = input
            @template_path = input
          else
            @content = input
          end
          @load_paths = options.delete(:load_paths) || [""]
          @root = options.delete(:root)
        end

        def match_extends_line(content)
          extends_pattern = /\{% extends "([\.\w-]+)" %\}/
          match_data = content.match(extends_pattern)
          return unless match_data
          match_data.captures[0]
        end

        def lookup_layout
          match_extends_line(@content)
        end

        def lookup_layouts
            recursively_lookup_layouts_for_file(input)
        end

        private

        def recursively_lookup_layouts_for_file(input, template_list=[])

            parent_template = match_file input, root

            if parent_template
                normalized_path = NormalizesPathToTemplate(parent_template, load_paths)
                template_list << normalized_path
                # TODO: Not a fan of Dir.pwd here, but it will always work. Is there a better way to get the correct input root?
                input = Rake::Pipeline::FileWrapper.new(Dir.pwd, normalized_path)
                recursively_lookup_layouts_for_file(input, template_list)
            end

            template_list
        end

        def match_file(input, root)
          return unless File.exist?(input.path)
          content = File.read(input.path)
          match_extends_line(content)
        end

    end
end
