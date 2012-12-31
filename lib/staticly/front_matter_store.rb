# TODO: This guy needs SERIOUS help

module FrontMatterStoreHelpers
  def key_for_filename(filename)
      filename
  end
end

module Staticly
  class FrontMatterStore

      def self.store
          @store ||= Hash.new
      end

      def self.values
          store.values
      end

      def self.has_metadata_for_page?(key)
          store.key? key
      end

      def self.save(key,metadata)
          store[key] ||= {}

          # Make sure we don't clobber content
          m = metadata.dup
          m.delete("content")

          store[key].merge!(m)
          resolve_deleted_keys!(key, m)

      end

      def self.set_content_for_page!(key, content)
          store[key] ||= {}
          store[key].merge!("content" => content)
      end

      def self.set_metadata_for_page(key,metadata)
          return if !has_metadata_for_page?(key)
          store[key].merge! metadata
      end

      def self.[]=(key,value)
          store[key] = value
      end

      def self.resolve_deleted_keys!(key, new_hash)
          deleted_keys = store[key].keys - new_hash.keys
          store[key].delete_if do |k,_|
              deleted_keys.include? k
          end
      end

      def self.clear_all_metadata
          @store = nil
      end

      def self.[](key)
          store[key]
      end

      def self.inspect
          store.inspect
      end

  end
  FrontMatterStore.extend(FrontMatterStoreHelpers)
end


