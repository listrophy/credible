# -*- encoding: utf-8 -*-
require File.expand_path('../lib/credible/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bradley Grzesiak"]
  gem.email         = ["brad@bendyworks.com"]
  gem.description   = %q{Store credentials in your repository safely}
  gem.summary       = %q{Store credentials in your repository safely}
  gem.homepage      = "https://github.com/listrophy/credible"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "credible"
  gem.require_paths = ["lib"]
  gem.version       = Credible::VERSION
end
