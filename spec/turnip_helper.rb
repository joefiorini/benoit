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
end
