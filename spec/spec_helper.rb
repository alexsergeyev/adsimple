require File.join(File.dirname(__FILE__), '..', 'lib', 'adsimple.rb')
require 'rack/test'
require 'rspec'
require 'webrat'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging

RSpec.configure do |config|
  config.include Webrat::Matchers
end
