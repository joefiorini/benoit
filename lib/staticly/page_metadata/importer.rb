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

      def self.import_metadata(path, content)
        key = memoized_key(path)
        if respond_to?(key)
          send key
        else
          metadata = Parser.parse(content)
          memoize_metadata(key, metadata)
          metadata
        end
      end

      private

      def self.memoize_metadata(key, metadata)
        create_method key do
          metadata
        end
      end

      def self.create_method(name, &body)
        singleton_class.instance_eval do
          define_method name, &body
        end
      end

      def self.memoized_key(path)
        :"__#{path.gsub(/[\.\/]/, "_")}_metadata"
      end

    end
  end
end
