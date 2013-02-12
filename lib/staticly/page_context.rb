#
#  PageContext.rb
#  Staticly
#
#  Created by Joseph Fiorini on 10/22/12.
#  Copyright 2012 densitypop. All rights reserved.
#

require 'ostruct'

module Staticly
  class PageContext
      attr_reader :full_content, :attrs_hash, :siteContext, :permalink

      def self.from_hash(page_attrs)
          new(page_attrs)
      end

      def initialize(attrs)
          @attr_names = @attrNames = []
          @original_path = attrs["_original_path"]
          setFileType!(attrs)
          set_permalink!(attrs)
          @metadata = methodsFromAttrs(attrs)
      end

      def template
          # For compat with other site generators
          @template || @layout
      end

      def has_value?(value)
        @metadata.has_value?(value)
      end

      def [](key)
        @metadata[key]
      end

      def keys
        @metadata.keys
      end

      def set_permalink!(attrs)
        @permalink = "/#{@original_path}"
        @attrNames << :permalink
      end

      def to_json(options={})
          attrsFromMethods(@attrNames).to_json
      end

      def to_hash(options={})
          attrsFromMethods(@attrNames)
      end

      private

      def setFileType!(attrs)
          attrs["_type"] = attrs["type"] || "page"
      end

      def methodsFromAttrs(attrs)
          self.class.send :attr_reader, *attrs.keys.map(&:to_sym)
          attrs.each do |k,v|
              @attrNames << k.to_sym
              self.instance_variable_set "@#{k}", v
          end
      end

      def attrsFromMethods(attrs, &transformer)
          attrs.inject({}) do |acc,attr,v|
              value = send attr
              acc[attr] = value
              acc
          end
      end

      def pagination_config(attrs, &block)
        attrs.select do |k,v|
          keys = k.to_s.scan(/(\w+)_per_page/)
          if keys.any?
            block.(v)
          end
        end
      end

  end
end
