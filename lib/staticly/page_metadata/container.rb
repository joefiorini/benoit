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
        return unless respond_to? key
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
  end
end

