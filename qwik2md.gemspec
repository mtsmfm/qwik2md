# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qwik2md/version'

Gem::Specification.new do |spec|
  spec.name          = "qwik2md"
  spec.version       = Qwik2md::VERSION
  spec.authors       = ["Fumiaki MATSUSHIMA"]
  spec.email         = ["mtsmfm@gmail.com"]

  spec.summary       = %q{Convert qwik to markdown}
  spec.description   = %q{Convert qwik to markdown}
  spec.homepage      = 'https://github.com/mtsmfm/qwik2md'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "vendor/qwik/lib"]
  spec.add_dependency "htree", "~> 0.7"
  spec.add_dependency "algorithm-diff", "~> 0.1"
  spec.add_dependency "iconv", "~> 1.0"
  spec.add_dependency "reverse_markdown", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
end
