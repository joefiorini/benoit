module Staticly
  module PageMetadata
    class JsonConverter

      def self.import!(json, store=Store.current)
        hash = JSON.parse(json)
        store.import_all!(hash)
      end

      def self.export(store=Store.current)
        store.to_hash.to_json
      end

    end

    class SiteContextConverter

      def self.export(store=Store.current)
        store.to_hash.inject({}) do |ctxt,(key,metadata)|
          new_key = store.path_from_key(key)
          ctxt.merge(new_key => metadata)
        end
      end

    end
  end
end

