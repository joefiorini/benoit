# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','benoit','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'benoit'
  s.version = Benoit::VERSION
  s.author = 'Joe Fiorini'
  s.email = 'joe@joefiorini.com'
  s.homepage = 'http://github.com/joefiorini/benoit'
  s.platform = Gem::Platform::RUBY
  s.summary = 'The CLI interface behind the Benoit Mac app'

  vendor_files = `git submodule foreach git ls-files`.split("\n")
  vendor_files =
    vendor_files.map do |file|
      if match = /^Entering '(.*)'$/.match(file)
        @current_dir = match[1]
        nil
      else
        File.join(@current_dir, file)
      end
    end.compact

  s.files = `git ls-files -z`.split("\0") + vendor_files

  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'benoit'

  s.add_dependency "gli", "~> 2.5.3"
  s.add_dependency "sass", "~> 3.2.0"
  s.add_dependency "multi_json", "~> 1.5.0"
  s.add_dependency "redcarpet", "~> 2.2.2"
  s.add_dependency "compass", "~> 0.13.alpha"
  s.add_dependency "chunky_png", "~> 1.2.0"
  s.add_dependency "inflecto", "~> 0.0.2"
  s.add_dependency "cadenza", "~> 0.8.0"
  s.add_dependency "rake-pipeline-web-filters", "~> 0.7.0"
  s.add_dependency "kronic", "~> 1.1.3"
  s.add_dependency "stamp", "~> 0.5.0"


  s.add_development_dependency "rspec"
  s.add_development_dependency "turnip", "~> 1.1.0"
  s.add_development_dependency "turnip-kanban"
  s.add_development_dependency "aruba"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "pry-remote"

end
