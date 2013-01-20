# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "frontmatter/version"

Gem::Specification.new do |s|
  s.name        = "frontmatter"
  s.version     = Frontmatter::VERSION
  s.authors     = ["docunext"]
  s.email       = ["albert.lash@docunext.com"]
  s.homepage    = "http://www.docunext.com/wiki/YAML"
  s.summary     = %q{A gem to handle front matter}
  s.description = %q{This gem is all about frontmatter.}

  s.rubyforge_project = "frontmatter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "cucumber"
  # s.add_runtime_dependency "rest-client"
end