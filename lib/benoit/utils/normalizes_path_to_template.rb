#
#  NormalizesPathToTemplate.rb
#  Benoit
#
#  Created by Joseph Fiorini on 10/29/12.
#  Copyright 2012 densitypop. All rights reserved.
#

def NormalizesPathToTemplate(template, load_paths)
    Benoit::Utils::NormalizesPathToTemplate.new(template, load_paths).
        normalize_path
end

module Benoit
  module Utils
    class NormalizesPathToTemplate
        attr_accessor :template_path, :load_paths

        def initialize(template_path, load_paths)
            @template_path = template_path
            @load_paths = load_paths
        end

        def normalize_path
            return template_path if File.exist?(template_path) # Already normalized, just return it
            load_paths.inject(template_path) do |actual_path,load_path|
                path_to_try = actual_path
                if not File.basename(path_to_try).start_with? "_"
                  path_to_try = File.join(File.dirname(path_to_try), "_#{File.basename(path_to_try)}")
                end
                path_to_try += ".html" unless File.extname(path_to_try) == ".html"
                return path_to_try if File.exist?(path_to_try)
                path_to_try = File.join(load_path, path_to_try)
                if File.exist?(path_to_try)
                    path_to_try
                else
                    actual_path
                end
            end
        end
    end
  end
end
