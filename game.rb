require 'json'

require 'gosu'
require 'chipmunk'

require_relative './src/debug_dialog.rb'
require_relative './src/track.rb'
require_relative './src/interfaced_array.rb'
require_relative './src/game_object_interface.rb'
require_relative './src/input/drive_car.rb'
require_relative './src/presentation/present_car.rb'

# Main game window
class GameWindow < Gosu::Window
  WIDTH = Track::TILE_SIZE * 10
  HEIGHT = Track::TILE_SIZE * 6

  DAMPING = 0.3

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Gosu Tutorial Game'

    debug_dialog = DebugDialog.new(window: self)
    @debug = false

    @space = CP::Space.new

    @objects = InterfacedArray.new
    @objects.interface = GameObjectInterface
    @objects << debug_dialog

    @commanders = []
    @presentations = []

    load_map!
    load_car!
    load_loose_tires!
    @space.damping = DAMPING
  end

  def update
    commands = @commanders.map(&:commands).flatten

    @objects.each do |obj|
      obj.update(commands: commands)
    end

    @space.step(update_interval / 1000)
  end

  def draw
    @objects.each { |o| o.draw(debug: @debug) }
    @presentations.each(&:draw)
    return unless @debug
    draw_debug_overlay
  end

  def load_map!
    current_map = File.open('maps/test_track_1.json') do |file|
      JSON.load(file)
    end
    track = Track.new(map: current_map, space: @space)
    @objects << track
    @pole_position = track.pole_position
  end

  def load_car!
    load('./src/car.rb')
    x, y = *@pole_position
    car = Car.new(x: x, y: y, space: @space)
    @objects << car
    @presentations << PresentCar.new(model: car)
    @commanders << DriveCar.new(actor: car)
  end

  def load_loose_tires!
    load('./src/loose_tire.rb')
    @objects << LooseTire.new(x: WIDTH / 4, y: HEIGHT / 4, space: @space)
    @objects << LooseTire.new(x: WIDTH / 4 + 30, y: HEIGHT / 4, space: @space)
    @objects << LooseTire.new(x: WIDTH / 4 + 15, y: HEIGHT / 4 + 25, space: @space)
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
