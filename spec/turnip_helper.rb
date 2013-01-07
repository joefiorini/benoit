require 'aruba/rspec' # loaded from spec/support
require 'turnip/kanban'

module Staticly
end

Dir["spec/steps/**/*.rb"].each do |step_file|
  load step_file
end

RSpec.configure do |config|
  config.include RunSteps
  config.include StaticlySteps

  config.before :each do
    @aruba_timeout_seconds = 10
    FileUtils.rm_rf File.expand_path("~/.staticly/tmpcache")
  end
end
