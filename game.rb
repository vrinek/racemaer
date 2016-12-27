require 'json'

require 'gosu'

require_relative './debug_dialog.rb'
require_relative './car.rb'
require_relative './track.rb'

# Main game window
class GameWindow < Gosu::Window
  WIDTH = Track::TILE_SIZE * 10
  HEIGHT = Track::TILE_SIZE * 6

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Gosu Tutorial Game'

    @debug_dialog = DebugDialog.new(window: self)

    reload_map!

    @car = Car.new(WIDTH / 2, HEIGHT / 2)
  end

  def update
    @debug_dialog.update
    @track.update
    @car.update
  end

  def draw
    @debug_dialog.draw
    @track.draw
    @car.draw
  end

  def reload_map!
    test_track_1 = File.open('maps/test_track_1.json') do |file|
      JSON.load(file)
    end
    @track = Track.new(map: test_track_1)
  end
end

window = GameWindow.new
window.show
