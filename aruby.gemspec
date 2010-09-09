require File.expand_path("../lib/aruby/version", __FILE__)

Gem::Specification.new do |s|
  s.name          = "aruby"
  s.version       = ARuby::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Joshua Hollenbeck"]
  s.email         = ["josh.hollenbeck@citrusbyte.com"]
  s.homepage      = "http://tbd.com"
  s.summary       = "Compile ruby code into Actionscript SWF file."
  s.description   = "ARuby is a tool for compiling Ruby code into a Actionscript SWF file."

  s.required_rubygems_version = ">= 1.3.6"
#  s.rubyforge_project         = "aruby"

  s.add_development_dependency "rake"
  s.add_development_dependency "contest", ">= 0.1.2"
  s.add_development_dependency "mocha"
  s.add_development_dependency "ruby-debug"
  s.add_development_dependency "bundler", ">= 1.0.0.rc.6"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path  = 'lib'
end
