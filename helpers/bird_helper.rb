module BirdHelper
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  def json_params
    JSON.parse(request.body.read)
  rescue
    halt 400, { message: 'Invalid JSON' }.to_json
  end

  def bird
    @bird ||= Bird.where(id: params[:id]).first
  end

  def halt_if_not_record_found!
    halt(404, { message: 'Bird Not Found' }.to_json) unless bird
  end

  def validate_post_json(json) 
    json_file = File.read('bird.json')
    schema =  JSON::Validator.validate(json_file, json)
    halt 400, { message: 'Invalid JSON' }.to_json unless schema
    JSON.parse(json)
  rescue
    halt 400, { message: 'Invalid JSON' }.to_json
  end

  def serialize(bird)
    BirdSerializer.new(bird).to_json
  end
end