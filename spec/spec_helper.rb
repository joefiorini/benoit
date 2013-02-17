require_relative "../bundle/bundler/setup"
require 'rake'

require "pry"
require "pry-nav"

require "spec_helpers/memory_file_wrapper"
require "spec_helpers/memory_manifest"


class String
  def unindent
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end

