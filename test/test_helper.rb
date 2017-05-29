require_relative '../route/server'
require_relative '../test/bird_factory'
require 'test/unit'
require 'rack/test'
require 'factory_girl'

set :environment, :test

# Test Case for bird
class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end