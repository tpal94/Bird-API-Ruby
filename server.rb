# server.rb
require 'sinatra'
require "sinatra/namespace"
require 'mongoid'
require_relative 'bird' 
require_relative 'serializer'


# DB Setup
Mongoid.load! "mongoid.config"




# Endpoints
get '/' do
  'Welcome to BirdList!'
end

namespace '/api/v1' do

  before do
    content_type 'application/json'
  end

  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def json_params
      begin
        JSON.parse(request.body.read)
      rescue
        halt 400, { message: 'Invalid JSON' }.to_json
      end
    end

    def bird
      @Bird ||= Bird.where(id: params[:id]).first
    end

    def halt_if_not_record_found!
      halt(404, { message: 'Bird Not Found'}.to_json) unless bird
    end

    def serialize(bird)
      BirdSerializer.new(bird).to_json
    end
  end

  get '/birds' do
    birds = Bird.only_visible
    [:name, :family].each do |filter|
      birds = Birds.send(filter, params[filter]) if params[filter]
    end
    birds.map { |bird| BirdSerializer.new(bird) }.to_json
  end

  get '/birds/:id' do |id|
    halt_if_not_record_found!
    serialize(bird)
  end

  post '/birds' do
    bird = Bird.new(json_params)
    halt 400, serialize(bird) unless bird.save
    response.headers['Location'] = "#{base_url}/api/v1/birds/#{bird.id}"
    status 201
  end

  patch '/birds/:id' do |id|
    halt_if_not_record_found!
    halt 422, serialize(bird) unless bird.update_attributes(json_params)
    serialize(bird)
  end

  delete '/birds/:id' do |id|
    halt_if_not_record_found!
    Bird.destroy if bird
    status 200
  end

end
