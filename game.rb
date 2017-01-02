require 'json'

require 'gosu'
require 'chipmunk'

require_relative './src/debug_dialog.rb'
require_relative './src/track.rb'

# Main game window
class GameWindow < Gosu::Window
  WIDTH = Track::TILE_SIZE * 10
  HEIGHT = Track::TILE_SIZE * 6

  DAMPING = 0.3

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Gosu Tutorial Game'

    @debug_dialog = DebugDialog.new(window: self)
    @debug = false

    @space = CP::Space.new

    @objects = [@debug_dialog]

    load_map!
    load_car!
    load_loose_tires!
    @space.damping = DAMPING
  end

  def update
    @objects.each(&:update)

    @space.step(update_interval / 1000)
  end

  def draw
    @objects.each { |o| o.draw(debug: @debug) }
    return unless @debug
    draw_debug_overlay
  end

  def load_map!
    current_map = File.open('maps/test_track_1.json') do |file|
      JSON.load(file)
    end
    @objects << Track.new(map: current_map, space: @space)
  end

  def load_car!
    load('./src/car.rb')
    @objects << Car.new(x: WIDTH / 2, y: HEIGHT / 4, space: @space)
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
