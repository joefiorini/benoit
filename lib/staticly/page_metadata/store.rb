require 'singleton'

module Staticly
  module PageMetadata

    class Store
      include Singleton

      class << self
        alias current instance
      end

      def initialize
        @container = container_class.new
      end

      def import_from_page(input)
        if Parser.should_parse?(input.path)
          import_metadata(input.path, input.read)
        else
          {}
        end
      end

      def import_all!(hash)
        @container = container_class[hash]
      end

      def [](page_name)
        return unless @container
        @container[memoized_key(page_name)]
      end

      def has_page?(page_name)
        return unless @container
        @container.key?(memoized_key(page_name))
      end

      def to_hash
        return unless @container
        @container.to_hash
      end

      def expire!
        @container.clear
      end

      def import_metadata(path, content)
        key = memoized_key(path)
        if @container.respond_to?(:key?) and @container.key?(key)
          @container[key]
        else
          @container ||= container_class.new
          @container[key] = Parser.parse(content)
        end
      end

      private

      def memoized_key(path)
        :"__#{path.gsub(/[\.\/]/, "_")}_metadata"
      end

      def container_class
        Class.new(Container)
      end

    end
  end
end
