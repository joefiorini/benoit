module Benoit
  class Server
    class Remote

      def initialize
      end

      def call(env)
        code = 200

        case env['PATH_INFO']
        when '/clean'
          Benoit::Cleaner.run
          body = "cleaned"
        end

        code = 200 if body
        body || (body, code = ["not found", 404])

        [code, {"Content-Type" => "application/json"}, {response: body}.to_json]
      end

    end
  end
end
