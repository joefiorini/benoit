require 'psych'
require 'frontmatter'

module Staticly
  module PageMetadata
    class Parser

      def self.should_parse?(path)
        FrontMatter.file_might_have_frontmatter?(path) ||
          FrontMatter.file_has_frontmatter?(path)
      end

      def self.parse(input)
        content = input.read
        if FrontMatter.has_frontmatter?(content)
          FrontMatter.parse(content)
        else
          {}
        end
      end

    end
  end
end
