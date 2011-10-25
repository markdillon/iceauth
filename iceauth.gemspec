# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "iceauth/version"

Gem::Specification.new do |s|
  s.name        = "iceauth"
  s.version     = Iceauth::VERSION
  s.authors     = ["Mark Dillon"]
  s.email       = ["mdillon@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Generate authentication for an icebreaker based rails application}
  s.description = %q{Generate authentication for an icebreaker based rails application}

  s.rubyforge_project = "iceauth"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
