module Benoit
  class Server
    class Remote

      def initialize(project)
        @project = project
      end

      def call(env)
        code = 200

        case env['PATH_INFO']
        when '/clean'
          Benoit::Cleaner.run
          body = "cleaned"
        when '/build'
          @project.invoke
          body = "built"
        end

        code = 200 if body
        body || (body, code = ["not found", 404])

        [code, {"Content-Type" => "application/json"}, {response: body}.to_json]
      end

    end
  end
end
