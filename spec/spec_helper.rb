require "pry"
require "pry-nav"
require_relative "../bundle/bundler/setup"

class String
  def unindent 
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end

