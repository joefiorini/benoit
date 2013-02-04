require 'delegate'

module Staticly
  class CurrentSite < SimpleDelegator
    def self.load
      context_hash = PageMetadata::SiteContextConverter.export
      new(Staticly::SiteContext.from_hash(context_hash))
    end
  end
end


