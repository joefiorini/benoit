module Staticly
  module PageMetadata

    class Importer

      def self.import_from_page(input)
        if Parser.should_parse?(input.path)
          import_metadata(input.path, input.read)
        else
          {}
        end
      end

      def self.import_all!(hash)
        @container = container_class[hash]
      end

      def self.[](page_name)
        return unless @container
        @container[memoized_key(page_name)]
      end

      def self.has_page?(page_name)
        return unless @container
        @container.key?(memoized_key(page_name))
      end

      def self.to_hash
        return unless @container
        @container.to_hash
      end

      def self.expire!
        @container.clear
      end

      def self.import_metadata(path, content)
        key = memoized_key(path)
        if @container.respond_to?(:key?) and @container.key?(key)
          @container[key]
        else
          @container ||= container_class.new
          @container[key] = Parser.parse(content)
        end
      end

      private

      def self.memoized_key(path)
        :"__#{path.gsub(/[\.\/]/, "_")}_metadata"
      end

      def self.container_class
        Class.new(Container)
      end

    end
  end
end
