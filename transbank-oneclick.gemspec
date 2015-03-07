# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transbank/oneclick/version'

Gem::Specification.new do |spec|
  spec.name          = "transbank-oneclick"
  spec.version       = Transbank::Oneclick::VERSION
  spec.authors       = ["Ramón Soto"]
  spec.email         = ["ramon.soto@clouw.com"]
  spec.summary       = %q{transbank oneclick.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '>= 4.0'
  spec.add_development_dependency 'mocha', '>= 1.1.0'
  spec.add_development_dependency 'webmock', '>= 1.20'


  spec.add_dependency 'nokogiri', '>= 1.4.0'
end
