# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snipp/version'

Gem::Specification.new do |gem|
  gem.name          = "snipp"
  gem.version       = Snipp::VERSION
  gem.authors       = ["yulii"]
  gem.email         = ["yuliinfo@gmail.com"]
  gem.description   = %q{Structured Data Snippets}
  gem.summary       = %q{Let search engines understand the content on your website}
  gem.homepage      = "https://github.com/yulii/snipp"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rails', '>= 3.2.11'
end
