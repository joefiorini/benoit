#
#  TemplateLayoutLookup.rb
#  Staticly
#
#  Created by Joseph Fiorini on 10/29/12.
#  Copyright 2012 densitypop. All rights reserved.
#

def FindsLayoutsForTemplate(template_path, options={})
    Staticly::Utils::FindsLayoutsForTemplate.new(template_path, options).lookup_layouts
end

module Staticly::Utils
    class FindsLayoutsForTemplate

        FrontMatterLookupStrategy = ->(template_path) {
              metadata = FrontMatterStore[template_path]
              return unless metadata
              parent_template = metadata["layout"] || metadata["template"]
              parent_template
        }

        CadenzaInheritanceLookupStrategy = ->(template_path) {
            extends_pattern = /\{% extends "([\.\w_-]+)" %\}/
            return unless File.exist?(template_path)
            match_data = File.read(template_path).match(extends_pattern)
            return unless match_data
            parent_template = match_data.captures[0]
        }

        attr_reader :root, :template_path, :load_paths

        def initialize(file, options)
            @load_paths = options.delete(:load_paths) || [""]
            @root = options.delete(:root)
            @template_path = file
        end

        def lookup_layouts
            recursively_lookup_layouts_for_file(template_path)
        end

        private

        def recursively_lookup_layouts_for_file(file, template_list=[])

            parent_template = call_strategy_for_file file, root

            if parent_template
                parent_template = NormalizesPathToTemplate(parent_template, load_paths)
                template_list << parent_template
                recursively_lookup_layouts_for_file(parent_template,
                     template_list)
            end

            template_list
        end

        def call_strategy_for_file(file, root)
            strategies = [FrontMatterLookupStrategy, CadenzaInheritanceLookupStrategy]
            strategies.inject(nil) do |parent_template,strategy|
                strategy.call(file) || parent_template
            end
        end

    end
end
