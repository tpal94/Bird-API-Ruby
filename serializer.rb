# Serializers
class BirdSerializer

  def initialize(bird)
    @bird = bird
  end

  def as_json(*)
    data = {
      id: @bird.id.to_s,
      name: @bird.name,
      family: @bird.family,
      continents: @bird.continents,
      added: @bird.added,
      visible: @bird.visible,


    }
    data[:errors] = @bird.errors if @bird.errors.any?
    data
  end

end