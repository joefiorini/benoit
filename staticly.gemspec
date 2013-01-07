# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','staticly','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'staticly'
  s.version = Staticly::VERSION
  s.author = 'Joe Fiorini'
  s.email = 'joe@joefiorini.com'
  s.homepage = 'http://static.ly'
  s.platform = Gem::Platform::RUBY
  s.summary = 'The CLI interface behind the Staticly Mac app'

  vendor_files = `(cd .. && git submodule foreach git ls-files)`.split("\n")
  vendor_files =
    vendor_files.map do |file|
      if match = /^Entering 'Staticly CLI\/(.*)'$/.match(file)
        @current_dir = match[1]
        nil
      else
        File.join(@current_dir, file)
      end
    end.compact

  s.files = `git ls-files -z`.split("\0") + vendor_files

  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'staticly'
end
