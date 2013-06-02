require 'rake-pipeline/middleware'
require 'rack/server'


module Benoit
  class Server < Rack::Server

    require_relative 'server/remote'

    DEFAULT_APP = proc { [404, { "Content-Type" => "text/plain" }, ["not found"]] }

    def initialize(project, options={})
      @project = project
      super options
    end

    def app
      project = @project.project
      Rack::Builder.new do
        use Rack::ShowExceptions
        use CustomExceptionHandler
        map "/_remote" do
          run Benoit::Server::Remote.new
        end
        run Rake::Pipeline::Middleware.new DEFAULT_APP, project
      end.to_app
    end

  end

  class CustomExceptionHandler

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue StandardError => ex
      Benoit::Cleaner.run
      Logger.error "#{ex.message} (#{ex.class.name})"
      Logger.error ex.backtrace.join("\n")
      raise ex
    end

  end
end
