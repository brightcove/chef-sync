# -*- encoding: utf-8 -*-
require File.expand_path('../lib/chef-sync/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Winfield Peterson"]
  gem.email         = ["wpeterson@brightcove.com"]
  gem.description   = %q{Synchronize Chef w/ Cap, Mongro, etc}
  gem.summary       = %q{Synchronize Chef nodes w/ Capistrano and other config}
  gem.homepage      = "http://github.com/brightcove/chef-sync"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "chef-sync"
  gem.require_paths = ["lib"]
  gem.version       = Chef::Sync::VERSION

  gem.add_runtime_dependency 'chef'

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "mocha"
end
