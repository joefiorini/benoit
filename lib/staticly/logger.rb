require 'syslog'

module Staticly
  class Logger

    def self.report_error(ex)
      error ex.message
      error ex.backtrace.join("\n")
      error(ENV.map { |k,v| "#{k}=#{v}" }.join("\n"))
    end

    def self.critical(*msg)
      logger.crit(*msg)
    end

    def self.error(*msg)
      puts msg.inspect
      logger.err(*msg)
    end

    def self.warn(*msg)
      logger.warning(*msg)
    end

    def self.emergency(*msg)
      logger.emerg(*msg)
    end

    def self.notice(*msg)
      logger.notice(*msg)
    end

    def self.logger
      @logger ||= Syslog.open("com.densitypop.Staticly", Syslog::LOG_CONS, Syslog::LOG_USER)
    end
  end
end
