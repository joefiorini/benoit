#
#  LoadsSiteContent.rb
#  Benoit
#
#  Created by Joseph Fiorini on 10/22/12.
#  Copyright 2012 densitypop. All rights reserved.
#

require 'json'
require 'inflecto'
require 'cadenza/context_object'

module Benoit
  class SiteContext

    class ContextObject < ::Cadenza::ContextObject
      def initialize(site)
        @site = site
        @pages = site.pages
      end

      def lookup_resource_collection(name)
        singular_name = Inflecto.singularize(name)
        collection = @pages.select do |page|
          page["_type"] == singular_name
        end

        collection.map!(&:to_hash)
      end

      def paginated_collection(name)
        potential_collection = @site.paginated_collections[name].last
        if potential_collection.respond_to? :at_end?
          potential_collection.rewind_list! if potential_collection.at_end?
          return potential_collection
        end

        per_page = @site.paginated_collections[name].first
        collection = lookup_resource_collection(name)

        collection.paginate(per_page).tap do |coll|
          @site.paginated_collections[name] << coll
        end
      end

      def resource_collection(name)
        lookup_resource_collection(name)
      end

      def method_missing(msg,*args)
        name = msg.to_s
        parsed_name = Inflecto.singularize(name).sub(/paginated_/, "")

        valid_page = @pages.any? { |page| page.has_value?(parsed_name) }

        if valid_page and name.start_with? "paginated_"
          return paginated_collection(parsed_name)
        elsif valid_page
          return resource_collection(name)
        else
          # The key we are looking for has no content,
          # therefore we can return an empty array
          []
        end

      end
      alias_method :missing_context_method, :method_missing

    end

      def self.from_hash(context_attrs)
          page_contexts = context_attrs.values.map do |context|
              Page.from_hash(context)
          end
          new(page_contexts)
      end

    attr_reader :pages

    attr_accessor :paths_map

      def initialize(pages)
          @pages = pages
      end

      def [](key)
        key = paths_map[key] if paths_map.key?(key)
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
        @paginated_collections ||= Hash.new([])
        @paginated_collections[collection] << per_page
      end

      def self.paginated_collections
        @paginated_collections
      end

      def self.clear_paginated_collections!
        @paginated_collections.clear if @paginated_collections
      end

    end
  end
