module Staticly::Filters
  class BlacklistFilter < Rake::Pipeline::Filter
    attr_accessor :whitelist

    def initialize(options={}, &block)
      @whitelist = options.delete(:allow)
      super &block
    end

    def generate_rake_tasks
      @rake_tasks = []
    end

    def output_files
      []
    end
  end
end
