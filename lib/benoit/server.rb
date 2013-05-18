require 'rake-pipeline/middleware'
require 'rack/server'

module Benoit
  class Server < Rack::Server
    def initialize(project)
      @project = project
    end

    def app
      not_found = proc { [404, { "Content-Type" => "text/plain" }, ["not found"]] }

      Rake::Pipeline::Middleware.new(not_found, @project.project)
    end
  end
end
