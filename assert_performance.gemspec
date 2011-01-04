# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "assert_performance/version"

Gem::Specification.new do |s|
  s.name        = "assert_performance"
  s.version     = AssertPerformance::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Justin Weiss"]
  s.email       = ["justin@uberweiss.org"]
  s.homepage    = "https://github.com/justinweiss/assert_performance"
  s.summary     = %q{Assert various performance characteristics of a block of code}
  s.description = %q{Assert various performance characteristics of a block of code}

  s.rubyforge_project = "assert_performance"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'sqlite3'
end
