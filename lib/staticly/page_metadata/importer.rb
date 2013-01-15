module Staticly
  module PageMetadata

    class Container

      def self.[](hash)
        hash.inject(new) do |inst,(key,value)|
          inst[key] = value
          inst
        end
      end

      def []=(key,value)
        create_method key do
          value
        end
      end

      def [](key)
        send key
      end

      def fetch(key)
        raise KeyError.new(key) unless key?(key)
        self[key]
      end

      def keys
        singleton_class.instance_methods(false)
      end

      def values
        keys.map do |key|
          send key
        end
      end

      def delete(key)
        destroy_method(key)
      end

      def clear
        keys.each do |key|
          delete key
        end
      end

      def to_hash
        Hash[keys.zip(values)]
      end

      def key?(key)
        respond_to? key
      end
      alias has_key? key? 

      private

      def create_method(name, &body)
        singleton_class.instance_eval do
          define_method name, &body
        end
      end

      def destroy_method(name)
        singleton_class.instance_eval do
          remove_method name
        end
      end

    end

    class Importer

      def self.import_from_page(input)
        if Parser.should_parse?(input.path)
          import_metadata(input.path, input.read)
        else
          {}
        end
      end

      def self.import_from_json(json)
        hash = JSON.parse(json)
        container_class = Class.new(Container)
        @container = container_class[hash]
      end

      def self.export_to_json
        return unless @container
        hash = @container.to_hash
        hash.to_json
      end

      def self.expire!
        @container.clear
      end

      def self.import_metadata(path, content)
        key = memoized_key(path)
        if @container.respond_to?(:key?) and @container.key?(key)
          @container[key]
        else
          @container ||= Class.new(Container).new
          @container[key] = Parser.parse(content)
        end
      end

      private

      def self.memoized_key(path)
        :"__#{path.gsub(/[\.\/]/, "_")}_metadata"
      end

    end
  end
end
