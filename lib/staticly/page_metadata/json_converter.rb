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
  end
end

