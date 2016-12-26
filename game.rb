require 'gosu'

require_relative './car.rb'

# Main game window
class GameWindow < Gosu::Window
  WIDTH = 640
  HEIGHT = 480

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Gosu Tutorial Game'

    @car = Car.new(WIDTH / 2, HEIGHT / 2)
  end

  def update
    @car.update
  end

  def draw
    @car.draw
  end
end

window = GameWindow.new
window.show
