# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bing/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Maher Hawash"]
  gem.email         = ["gmhawash@gmail.com"]
  gem.description   = %q{Bing Location API}
  gem.summary       = %q{Bing Location API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bing"
  gem.require_paths = ["lib"]
  gem.version       = Bing::VERSION

  gem.add_runtime_dependency "net-http-persistent"
  gem.add_runtime_dependency "json"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "rake"
end
