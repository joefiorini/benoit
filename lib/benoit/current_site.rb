require 'delegate'

module Benoit
  class CurrentSite < SimpleDelegator
    def self.load
      context_hash = PageMetadata::SiteContextConverter.export
      new(Benoit::SiteContext.from_hash(context_hash))
    end
  end
end


