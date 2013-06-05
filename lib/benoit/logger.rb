require 'syslog'

module Benoit
  class Logger

    def self.report_error(ex)
      original_error = ex.original_error if ex.respond_to? :original_error

      sub_message =
        if original_error
          "#{original_error.message}\n#{original_error.backtrace.join("\n")}"
        else
          ex.backtrace.join("\n")
        end

      message = <<-EOM
      Benoit encountered an error.

      #{ex}
      #{sub_message}

      #{ENV.map { |k,v| "#{k}=#{v}" }.join("\n")}
      EOM

      error message

      if Benoit.config.output_mode == :app
        $stderr.puts ex.to_json
      else
        $stderr.puts message
      end
    rescue StandardError => ex
      if Benoit.config.output_mode == :app
        $stderr.puts({ line_no: nil, message: ex.message, path: __FILE__ }.to_json)
      else
        $stderr.puts ex.message
        $stderr.puts ex.backtrace
      end
    end

    def self.critical(msg)
      self.log(:crit, msg)
    end

    def self.error(msg)
      self.log(:err, msg)
    end

    def self.warn(msg)
      self.log(:warning, msg)
    end

    def self.emergency(*msg)
      self.log(:emerg, msg)
    end

    def self.notice(*msg)
      self.log(:notice, msg)
    end

    def self.log(level, msg)
      logger.send(level, '%s', msg)
    end

    def self.logger
      @logger ||= Syslog.open("com.densitypop.Benoit", Syslog::LOG_CONS, Syslog::LOG_USER)
    end
  end
end
