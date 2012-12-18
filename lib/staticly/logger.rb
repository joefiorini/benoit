require 'syslog'

module Staticly
  class Logger

    def self.critical(*msg)
      logger.crit(*msg)
    end

    def self.error(*msg)
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
