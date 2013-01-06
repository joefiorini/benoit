require 'aruba/rspec' # loaded from spec/support
require 'turnip/kanban'

Dir["spec/steps/**/*.rb"].each do |step_file|
  load step_file
end

RSpec.configure do |config|
  config.include RunSteps
end
