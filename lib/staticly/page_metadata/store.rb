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
        metadata = Parser.parse(input)
        metadata["_original_path"] = input.path
        import_metadata(input.path, metadata)
      end

      def import_all!(hash)
        @container = container_class[hash]
      end

      def import_metadata(path, metadata)
        key = path_to_key(path)
        if @container.respond_to?(:key?) and @container.key?(key)
          @container[key]
        else
          @container ||= container_class.new
          @container[key] = metadata
        end
      end

      def [](wrapper)
        import_from_page(wrapper) unless has_page?(wrapper.path)
        @container[path_to_key(wrapper.path)] || {}
      end

      def has_page?(page_name)
        return unless @container
        @container.key?(path_to_key(page_name))
      end

      def to_hash
        return unless @container
        @container.to_hash
      end

      def expire!
        @container.clear
        @container = container_class.new
      end

      def path_from_key(key)
        key.to_s.sub /__([\w_]+)_metadata/ do |match,blah|
          $1.reverse.sub(/_/, ".").reverse
        end
      end

      def path_to_key(path)
        :"__#{path.gsub(/[\.\/]/, "_")}_metadata"
      end

      private

      def container_class
        Class.new(Container)
      end

    end
  end
end
