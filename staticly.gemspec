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
  s.files = `git ls-files -z`.split("\0")
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'staticly'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.5.3')
end
