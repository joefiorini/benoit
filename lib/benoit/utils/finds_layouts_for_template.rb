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


        FrontMatterLookupStrategy = ->(input) {
            input =
              if input.respond_to? :final_output and input.final_output
                input.final_output
              else
                input
              end
              metadata = Benoit::PageMetadata::Store.current[input]
              return unless metadata
              metadata["layout"] || metadata["template"]
        }

        CadenzaInheritanceLookupStrategy = ->(input) {
            extends_pattern = /\{% extends "([\.\w_-]+)" %\}/
            return unless File.exist?(input.path)
            match_data = File.read(input.path).match(extends_pattern)
            return unless match_data
            match_data.captures[0]
        }

        attr_reader :root, :template_path, :load_paths, :input

        def initialize(input, options)
            @load_paths = options.delete(:load_paths) || [""]
            @root = options.delete(:root)
            @template_path = input
            @input = input
        end

        def lookup_layouts
            recursively_lookup_layouts_for_file(input)
        end

        private

        def recursively_lookup_layouts_for_file(input, template_list=[])

            parent_template = call_strategy_for_file input, root

            if parent_template
                normalized_path = NormalizesPathToTemplate(parent_template, load_paths)
                template_list << normalized_path
                input = Rake::Pipeline::FileWrapper.new(Dir.pwd, normalized_path)
                # TODO: Not a fan of Dir.pwd here, but it will always work. Is there a better way to get the correct input root?
                recursively_lookup_layouts_for_file(input, template_list)
            end

            template_list
        end

        def call_strategy_for_file(input, root)
            strategies = [FrontMatterLookupStrategy]
            strategies.inject(nil) do |parent_template,strategy|
                strategy.call(input) || parent_template
            end
        end

    end
end
