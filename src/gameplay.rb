require_relative './interfaced_array.rb'
require_relative './interface/game_object.rb'

require_relative './gameplay/track.rb'
require_relative './gameplay/checkpoint.rb'
require_relative './gameplay/car.rb'
require_relative './gameplay/loose_tire.rb'

# Core gameplay component for the game
class Gameplay
  DAMPING = 0.3

  attr_reader :actors
  attr_reader :objects
  attr_reader :current_map

  def initialize(world_width:, world_height:)
    @world_width = world_width
    @world_height = world_height

    @space = CP::Space.new
    @space.damping = DAMPING

    @objects = InterfacedArray.new(interface: GameObject)
    @actors = {}

    load_map!
    load_track!
    load_checkpoints!
    load_car!
    load_loose_tires!
  end

  def update(commands:, update_interval:)
    commands.each { |cmd| @actors[cmd[:actor_id]].act(command: cmd) }

    @objects.each(&:update)
    @space.step(update_interval / 1000)
  end

  private

  def load_track!
    track = Track.new(map: current_map, space: @space)
    @objects << track
    @pole_position = track.pole_position
  end

  def load_map!
    @current_map = File.open('maps/test_track_1.json') do |file|
      JSON.parse(file.read).freeze
    end
  end

  def load_checkpoints!
    Checkpoint.new_with(map: current_map, space: @space).each do |checkpoint|
      @objects << checkpoint
    end
  end

  def load_car!
    x, y = *@pole_position
    car = Car.new(x: x, y: y, space: @space)
    @objects << car
    @actors[car.actor_id] = car
  end

  def load_loose_tires!
    initialize_tire(@world_width / 4, @world_height / 4)
    initialize_tire(@world_width / 4 + 30, @world_height / 4)
    initialize_tire(@world_width / 4 + 15, @world_height / 4 + 25)
  end

  def initialize_tire(x, y)
    @objects << LooseTire.new(x: x, y: y, space: @space)
  end
end
