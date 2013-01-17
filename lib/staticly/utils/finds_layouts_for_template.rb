#
#  TemplateLayoutLookup.rb
#  Staticly
#
#  Created by Joseph Fiorini on 10/29/12.
#  Copyright 2012 densitypop. All rights reserved.
#

def FindsLayoutsForTemplate(input, options={})
    Staticly::Utils::FindsLayoutsForTemplate.new(input, options).lookup_layouts
end

module Staticly::Utils

    class SimpleFileWrapper
      attr_reader :path

      def initialize(file_path)
        @path = file_path
      end
    end

    class FindsLayoutsForTemplate


        FrontMatterLookupStrategy = ->(input) {
              metadata = Staticly::PageMetadata::Store.current[input]
              return unless metadata
              parent_template = metadata["layout"] || metadata["template"]
              parent_template && SimpleFileWrapper.new(parent_template)
        }

        CadenzaInheritanceLookupStrategy = ->(input) {
            extends_pattern = /\{% extends "([\.\w_-]+)" %\}/
            return unless File.exist?(input.path)
            match_data = File.read(input.path).match(extends_pattern)
            return unless match_data
            parent_template = match_data.captures[0]
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
                parent_template = NormalizesPathToTemplate(parent_template.path, load_paths)
                template_list << parent_template.path
                recursively_lookup_layouts_for_file(parent_template,
                     template_list)
            end

            template_list
        end

        def call_strategy_for_file(input, root)
            strategies = [FrontMatterLookupStrategy, CadenzaInheritanceLookupStrategy]
            strategies.inject(nil) do |parent_template,strategy|
                strategy.call(input) || parent_template
            end
        end

    end
end
