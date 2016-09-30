# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'myrails/version'

Gem::Specification.new do |spec|
  spec.name          = "myrails"
  spec.version       = Myrails::VERSION
  spec.authors       = ["Vell"]
  spec.email         = ["lovell.mcilwain@gmail.com"]

  spec.summary       = %q{A thor backed generator for generating rails related files based on my style of coding}
  spec.description   = %q{Generates files with with boiler plate code. Supports pundit, presenters, installing of themes from bootswatch and others.}
  spec.homepage      = "https://github.com/vmcilwain/myrails"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir["{bin,lib}/**/*", "LICENSE.txt", "README.md", 'Rakefile', 'Gemfile', 'myrails.gemspec']
  spec.test_files    = Dir["spec/**/*"]
  spec.bindir        = "bin"
  spec.executables   = ['myrails']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency 'activesupport', '~> 5.0.0.1'
  spec.add_dependency 'thor', '~> 0.19.1'
end
