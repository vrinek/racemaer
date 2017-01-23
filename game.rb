require 'json'

require 'gosu'
require 'chipmunk'

require_relative './src/input.rb'
require_relative './src/presentation.rb'
require_relative './src/debug_presentation.rb'

require_relative './src/interfaced_array.rb'
require_relative './src/interface/game_object.rb'

require_relative './src/debug_dialog.rb'

require_relative './src/gameplay/track.rb'
require_relative './src/gameplay/checkpoint.rb'
require_relative './src/gameplay/car.rb'
require_relative './src/gameplay/loose_tire.rb'

# Main game window
class GameWindow < Gosu::Window
  WIDTH = 1280
  HEIGHT = 768

  DAMPING = 0.3

  COMMANDS_FILENAME = File.expand_path('../commands.rbm', __FILE__)

  attr_reader :current_map

  def initialize
    @debug = false # true / false

    super(WIDTH, HEIGHT)
    self.caption = 'Gosu Tutorial Game'

    @debug_dialog = DebugDialog.new(window: self)

    @space = CP::Space.new
    @space.damping = DAMPING

    @objects = InterfacedArray.new(interface: GameObject)

    @actors = {}

    load_map!
    load_track!
    load_checkpoints!
    load_car!
    load_loose_tires!

    @input = Input.new(actors: @actors)
    @presentation = Presentation.new(models: @objects)
    @debug_presentation = DebugPresentation.new(models: @objects)
  end

  def update
    if Gosu.button_down? Gosu::KbQ
      # shut down
      @input.destroy
      exit 0
    else
      # keep running
      @debug_dialog.update

      commands.each { |cmd| @actors[cmd[:actor_id]].act(command: cmd) }

      @objects.each(&:update)
      @space.step(update_interval / 1000)
    end
  end

  def draw
    @debug_dialog.draw
    @presentation.draw
    return unless @debug
    @debug_presentation.draw
    draw_debug_overlay
  end

  def load_track!
    track = Track.new(map: current_map, space: @space)
    @objects << track
    @pole_position = track.pole_position
  end

  def load_map!
    @current_map = File.open('maps/test_track_1.json') do |file|
      JSON.load(file)
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
    initialize_tire(WIDTH / 4, HEIGHT / 4)
    initialize_tire(WIDTH / 4 + 30, HEIGHT / 4)
    initialize_tire(WIDTH / 4 + 15, HEIGHT / 4 + 25)
  end

  def initialize_tire(x, y)
    @objects << LooseTire.new(x: x, y: y, space: @space)
  end

  def enable_debug!
    @debug = true
  end

  def draw_debug_overlay
    color = Gosu::Color.rgba(0, 0, 0, 128)
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, color, 10)
  end

  private

  def commands
    @input.commands
  end
end

window = GameWindow.new
window.show
