require_relative '../test_helper'
require_relative '../bird_factory'

class BirdTest < MyAppTest
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

  def test_the_bird_destroy
    bird = FactoryGirl.create(:bird)
    delete "/birds/#{bird.id}"
    assert last_response.ok?
    json = JSON.parse(last_response.body)
    assert json.present?
  end

  def test_invalid_fetch
    get '/birds/1'
    assert last_response.status.eql?(404)
  end
end