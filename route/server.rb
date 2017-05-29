# server.rb
require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'
require_relative '../models/bird'
require_relative '../serializers/bird_serializer'
require_relative '../helpers/bird_helper'
require "json-schema"
require 'pry'

# DB Setup
Mongoid.load! 'config/mongoid.config'

namespace '/api/v1' do
  before do
    content_type 'application/json'
  end
  
  helpers BirdHelper
   
  get '/' do
    'Welcome to BirdList!'
  end

  get '/birds' do
    birds = Bird.only_visible
    %i[name family].each do |filter|
      birds = Birds.send(filter, params[filter]) if params[filter]
    end
    birds.map { |bird| BirdSerializer.new(bird) }.to_json
  end

  get '/birds/:id' do
    halt_if_not_record_found!
    serialize(bird)
  end

  post '/birds' do
    params = validate_post_json(request.body.read)
    bird = Bird.new(params)     
    halt 400, serialize(bird) unless bird.save
    response.headers['Location'] = "#{base_url}/api/v1/birds/#{bird.id}"
    status 201
  end

  patch '/birds/:id' do
    halt_if_not_record_found!
    halt 422, serialize(bird) unless bird.update_attributes(json_params)
    serialize(bird)
  end

  delete '/birds/:id' do
    halt_if_not_record_found!
    Bird.destroy if bird
    status 200
  end
end
