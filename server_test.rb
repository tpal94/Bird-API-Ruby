require_relative 'server'
require 'test/unit'
require 'rack/test'
require 'factory_girl'


set :environment, :test
FactoryGirl.define do
   
  factory :bird do
    name "Marty McSpy"
    family "Hoverboard"
    continents ["Infiltration and espionage"]
    visible true
  end
 
end


class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_returns_welcome_message
    get '/'
    assert last_response.ok?
    assert_equal 'Welcome to BirdList!', last_response.body
  end

   def retrieve_specific_bird
    bird = FactoryGirl.create(:bird)    
    get "/api/v1/birds/#{bird.id}"

    # test for the 200 status-code
    assert last_response.ok?
     json = JSON.parse(last_response.body)
    puts json
    # check that the message attributes are the same.
    expect(json['content']).to eq(message.content) 

    # ensure that private attributes aren't serialized
    expect(json['private_attr']).to eq(nil) 	
  end

  def test_the_list_of_birds
  	
    get '/api/v1/birds'
    puts last_response.body
    json = JSON.parse(last_response.body)
    # test for the 200 status-code
    assert last_response.ok?

    # check to make sure the right amount of messages are returned
    assert_not_equal json.length, 10  	
  end

 



end