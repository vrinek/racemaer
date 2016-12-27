require 'gosu'

require_relative './car.rb'
require_relative './debug_dialog.rb'

# Main game window
class GameWindow < Gosu::Window
  WIDTH = 640
  HEIGHT = 480

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Gosu Tutorial Game'

    @debug_dialog = DebugDialog.new(window: self)
    @car = Car.new(WIDTH / 2, HEIGHT / 2)
  end

  def update
    @debug_dialog.update
    @car.update
  end

  def draw
    @debug_dialog.draw
    @car.draw
  end
end

window = GameWindow.new
window.show
