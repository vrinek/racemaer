require 'json'

require 'gosu'
require 'chipmunk'

require_relative './src/interfaced_array.rb'
require_relative './src/interface/game_object.rb'
require_relative './src/interface/presentation.rb'
require_relative './src/interface/commander.rb'

require_relative './src/debug_dialog.rb'

require_relative './src/gameplay/track.rb'
require_relative './src/presentation/present_track.rb'
require_relative './src/presentation/debug_track.rb'

require_relative './src/gameplay/checkpoint.rb'
require_relative './src/presentation/debug_checkpoint.rb'

require_relative './src/input/drive_car.rb'
require_relative './src/gameplay/car.rb'
require_relative './src/presentation/present_car.rb'
require_relative './src/presentation/debug_car.rb'

require_relative './src/gameplay/loose_tire.rb'
require_relative './src/presentation/present_loose_tire.rb'
require_relative './src/presentation/debug_loose_tire.rb'

# Main game window
class GameWindow < Gosu::Window
  WIDTH = 1280
  HEIGHT = 768

  DAMPING = 0.3

  attr_reader :current_map

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Gosu Tutorial Game'

    @debug_dialog = DebugDialog.new(window: self)
    @debug = false

    @space = CP::Space.new

    @objects = InterfacedArray.new(interface: GameObject)
    @commanders = InterfacedArray.new(interface: Commander)
    @presentations = InterfacedArray.new(interface: Presentation)
    @debug_presentations = InterfacedArray.new(interface: Presentation)

    load_map!
    load_track!
    load_checkpoints!
    load_car!
    load_loose_tires!
    @space.damping = DAMPING
  end

  def update
    @debug_dialog.update
    commands = @commanders.map(&:commands).flatten

    @objects.each do |obj|
      obj.update(commands: commands)
    end

    @space.step(update_interval / 1000)
  end

  def draw
    @debug_dialog.draw
    @presentations.each(&:draw)
    return unless @debug
    @debug_presentations.each(&:draw)
    draw_debug_overlay
  end

  def load_track!
    track = Track.new(map: current_map, space: @space)
    @objects << track
    @presentations << PresentTrack.new(model: track)
    @debug_presentations << DebugTrack.new(model: track)
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
      @debug_presentations << DebugCheckpoint.new(model: checkpoint)
    end
  end

  def load_car!
    x, y = *@pole_position
    car = Car.new(x: x, y: y, space: @space)
    @objects << car
    @presentations << PresentCar.new(model: car)
    @commanders << DriveCar.new(actor: car)
    @debug_presentations << DebugCar.new(model: car)
  end

  def load_loose_tires!
    initialize_tire(WIDTH / 4, HEIGHT / 4)
    initialize_tire(WIDTH / 4 + 30, HEIGHT / 4)
    initialize_tire(WIDTH / 4 + 15, HEIGHT / 4 + 25)
  end

  def initialize_tire(x, y)
    tire = LooseTire.new(x: x, y: y, space: @space)
    @objects << tire
    @presentations << PresentLooseTire.new(model: tire)
    @debug_presentations << DebugLooseTire.new(model: tire)
  end

  def enable_debug!
    @debug = true
  end

  def draw_debug_overlay
    color = Gosu::Color.rgba(0, 0, 0, 128)
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, color, 10)
  end
end

window = GameWindow.new
window.show
