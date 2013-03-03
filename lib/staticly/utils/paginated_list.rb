module Enumerable
  def paginate(per_page)
    Staticly::Utils::PaginatedList.new(self, per_page)
  end
end

module Staticly
  module Utils
    class PaginatedList
      include Enumerable

      attr_reader :per_page, :ops, :source, :enum

      def initialize(list, per_page=nil, &block)
        @ops = []
        @list = list
        @per_page = per_page
      end


      def each(&block)
        run_queued_operations!
        paginated.each do |page|
          block.call(page)
        end
      end

      def each_with_index(&block)
        run_queued_operations!
        paginated.each_with_index do |p,i|
          block.call(p, i)
        end
      end

      def paginated
        @enum ||= @list.each_slice(@per_page)
        @enum.next
      end

      def sort_by(&block)
        @ops << ->(list){
          list.sort_by(&block)
        }
        self
      end

      def map(&block)
        @ops << ->(list){
          list.map(&block)
        }
        self
      end

      def take(n)
        return self if @enum
        @ops << ->(list){
          list.take(n)
        }
        self
      end

      def reverse
        return self if @enum
        @ops << ->(list){
          list.reverse
        }
        self
      end

      def peek
        @enum.peek if @enum
      end

      def at_end?
        @enum.peek
        false
      rescue StopIteration
        true
      end

      def rewind_list!
        @enum.rewind
      end

      private

      def run_queued_operations!
        @list =
          @ops.inject(@list) do |l,op|
            op.call l
          end
      end

    end
  end
end
