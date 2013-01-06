require 'aruba'
require 'aruba/api'

RSpec.configure do |config|
  config.include Aruba::Api

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before :each, :"disable-bundler" do
    unset_bundler_env_vars
  end

  config.before :each do
    @__aruba_original_paths = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
    ENV['PATH'] = ([File.expand_path('bin')] + @__aruba_original_paths).join(File::PATH_SEPARATOR)
  end

  config.after :each do
    ENV['PATH'] = @__aruba_original_paths.join(File::PATH_SEPARATOR)
  end

  config.before :each do
    FileUtils.rm_rf(current_dir) unless example.metadata[:"no-clobber"]
  end

  config.before :each, :puts do
    @puts = true
  end

  config.before :each, :"announce-cmd" do
    @announce_cmd = true
  end

  config.before :each, :"announce-dir" do
    @announce_dir = true
  end

  config.before :each, :"announce-stdout" do
    @announce_stdout = true
  end

  config.before :each, :"announce-stderr" do
    @announce_stderr = true
  end

  config.before :each, :"announce-env" do
    @announce_end = true
  end

  config.before :each, :announce do
    @announce_stdout = true
    @announce_stderr = true
    @announce_cmd = true
    @announce_dir = true
    @announce_env = true
  end

  config.before :each, :ansi do
    @aruba_keep_ansi = true
  end

  config.after :each do
    restore_env
  end

end
