require 'rubygems'
require 'bundler/setup'

require 'chef-sync'

RSpec.configure do |config|
  config.mock_with :mocha
end