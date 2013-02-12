#
#  LoadsSiteContent.rb
#  Staticly
#
#  Created by Joseph Fiorini on 10/22/12.
#  Copyright 2012 densitypop. All rights reserved.
#

require 'json'
require 'inflector'
require 'cadenza/context_object'

module Staticly
  class SiteContext

    attr_reader :pages

    class ContextObject < Cadenza::ContextObject
      def initialize(site)
        @site = site
        @pages = site.pages
      end

      def method_missing(msg,*args)

        plural_name = msg.to_s
        name = Inflector.singularize(plural_name)

        return @paginated if @paginated

        if @pages.any? {|page| page.has_value?(name) }
          collection = @pages.select do |page|
            page["_type"] == name
          end

          collection.map! &:to_hash

          if @site.paginated_collection?(plural_name)
            per_page = @site.paginated_collections[plural_name]
            @paginated = collection = collection.paginate(per_page)
          end

          collection
        else
          super
        end

      end
      alias_method :missing_context_method, :method_missing

    end

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

      def to_context
        @context ||= ContextObject.new(self)
      end

      def paginated_collections
        self.class.paginated_collections
      end

      def paginated_collection?(key)
        unless self.class.paginated_collections.nil?
          self.class.paginated_collections.key?(key)
        end
      end

      def self.paginate_collection(collection, per_page)
        @paginated_collections ||= {}
        @paginated_collections.merge!(collection => per_page)
      end

      def self.paginated_collections
        @paginated_collections
      end

      def self.clear_paginated_collections!
        @paginated_collections.clear if @paginated_collections
      end

    end
  end
