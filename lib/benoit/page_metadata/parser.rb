require 'psych'
require 'frontmatter'
require 'kronic'

module Benoit
  module PageMetadata
    class Parser

      KEY_CONVERTERS = {
        "date" => ->(value){
          Kronic.parse(value)
        }
      }

      def self.should_parse?(path)
        FrontMatter.file_might_have_frontmatter?(path) ||
          FrontMatter.file_has_frontmatter?(path)
      end

      def self.parse(input)
        content = input.read
        if FrontMatter.has_frontmatter?(content)
          response = FrontMatter.parse(content)
          response.merge(response) do |key,original_value|
            if KEY_CONVERTERS.key?(key)
              KEY_CONVERTERS[key].(original_value)
            else
              original_value
            end
          end
        else
          {}
        end
      end

    end
  end
end
