# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-appcontroller"
  s.version     = "0.0.1" 
  s.authors     = ["rckcrlr"]
  s.email       = ["rckcrlr@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{App Controller for OSX} 
  s.description = %q{This plugin lets you start/stop and get status of Mac OSX apps through Siri commands}

  s.rubyforge_project = "siriproxy-appcontroller"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
