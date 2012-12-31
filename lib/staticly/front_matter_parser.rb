#
#  FrontMatterParser.rb
#  Staticly
#
#  Created by Joseph Fiorini on 10/22/12.
#  Copyright 2012 densitypop. All rights reserved.
#

require 'frontmatter'

module Staticly
  class FrontMatterParser

      def self.should_parse?(path)
          return unless FrontMatter.file_might_have_frontmatter?(path)
          return unless FrontMatter.file_has_frontmatter?(path)
          true
      end

      def self.parse(content)
          new(content).parse
      end

      def initialize(content)
          @content = content
      end

      def parse
          FrontMatter.parse(@content)
      end

  end
end
