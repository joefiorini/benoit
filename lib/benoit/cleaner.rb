module Benoit
  class Cleaner

    def self.run
      FileUtils.rm_rf(Benoit.config.cache_path)
      FileUtils.rm_rf(Benoit.config.output_path)
    end

  end
end
