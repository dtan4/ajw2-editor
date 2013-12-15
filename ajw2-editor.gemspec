# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ajw2/editor/version'

Gem::Specification.new do |spec|
  spec.name          = "ajw2-editor"
  spec.version       = Ajw2::Editor::VERSION
  spec.authors       = ["dtan4"]
  spec.email         = ["dtanshi45@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "sinatra"
  spec.add_dependency "slim"
  spec.add_dependency "sass"
  spec.add_dependency "coffee-script"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sinatra-reloader"
  spec.add_development_dependency "guard-livereload"
end
