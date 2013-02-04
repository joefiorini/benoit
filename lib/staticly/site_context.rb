#
#  LoadsSiteContent.rb
#  Staticly
#
#  Created by Joseph Fiorini on 10/22/12.
#  Copyright 2012 densitypop. All rights reserved.
#

require 'json'
require 'inflector'

module Staticly
  class SiteContext

      def self.from_hash(context_attrs)
          page_contexts = context_attrs.values.map do |context|
              PageContext.from_hash(context)
          end
          new(page_contexts)
      end

      def initialize(pages)
          @pages = pages
      end

      def [](key)
        page_with_path(key)
      end

      def page_with_path(path)
        @pages.find do |page|
          page.permalink == "/#{path}"
        end
      end

      def pages_grouped_by_type
          @pages.group_by do |page|
            Inflector.pluralize(page._type)
          end
      end

      def to_json(options={})
          to_hash.to_json
      end

      def to_hash
          page_collection_formatted_with &:to_hash
      end

      private

      def page_collection_formatted_with(&block)
          pages_grouped_by_type.inject({}) do |acc,(group,pages)|
              acc[group] = pages.map &block
              acc
          end
      end
  end
end
