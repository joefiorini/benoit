module Staticly
  module PageMetadata
    class JsonConverter

      def self.import!(json)
        hash = JSON.parse(json)
        Importer.import_all!(hash)
      end

      def self.export
        Importer.to_hash.to_json
      end

    end
  end
end

