module Staticly
  class Cleaner

    def self.run
      FileUtils.rm_rf(Staticly.config.cache_path)
      FileUtils.rm_rf(Staticly.config.output_path)
    end

  end
end
