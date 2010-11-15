# -*- encoding: utf-8 -*-
require File.expand_path("../lib/crom/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "crom"
  s.version     = Crom::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ 'Kamil Giszczak' ]
  s.email       = [ 'beerkg@gmail.com' ]
  s.homepage    = "http://rubygems.org/gems/crom"
  s.summary     = "Simple cron like scheduler"
  s.description = "Simple cron like scheduler"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "crom"

  s.add_runtime_dependency "rufus-scheduler", "~> 2.0.6"
  s.add_runtime_dependency "daemons"
  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
