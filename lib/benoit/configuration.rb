module Benoit
  module Configuration

    class Config

      attr_accessor :output_mode, :cache_path, :output_path, :site_path, :ignorefile
      attr_writer :clean_before_build

      def clean_before_build?
        @clean_before_build
      end

    end

    def configure(&block)
      block.call(config)
    end

    def config
      @config ||= Config.new
    end

  end
end
