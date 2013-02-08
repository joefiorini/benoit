module Staticly
  module Pipeline
    class PaginationMatcher < Rake::Pipeline::Matcher
      attr_reader :previous_input_files, :per_page_counts, :collection_totals

      def setup_filters
        @previous_input_files = pipeline.input_files
        calculate_collection_totals
        calculate_per_page_counts
        super
      end

      def output_files
        super + input_files
      end

      def eligible_input_files
        per_page_counts.keys
      end

      private

      def calculate_collection_totals
        @collection_totals ||=
          previous_input_files.group_by do |i|
            i.read.scan(/type: (\w+)/).flatten.first
          end.delete_if do |key,_|
            key.nil?
          end.reduce({}) do |acc,(key,val)|
            acc.merge(key => val.length)
          end
      end

      def calculate_per_page_counts
        @per_page_counts =
          previous_input_files.reduce([]) do |acc,i|
            collection, count = i.read.scan(/(\w+)_per_page: (\d+)/).flatten
            if collection
              collection = Inflector.singularize(collection) 
              acc << [i, collection, count.to_i]
            end
            acc
          end.reduce({}) do |acc,(input,collection,count)|
            total = collection_totals[collection]
            acc.merge(input => total / count + total % count)
          end
        end

    end
  end
end
