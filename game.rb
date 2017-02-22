require 'json'

require 'gosu'
require 'chipmunk'

require_relative './src/input.rb'
require_relative './src/gameplay.rb'
require_relative './src/presentation.rb'
require_relative './src/debug_presentation.rb'

require_relative './src/debug_dialog.rb'

# Main game window
class GameWindow < Gosu::Window
  WIDTH = 1280
  HEIGHT = 768

  def initialize
    @debug = false # true / false

    super(WIDTH, HEIGHT)
    self.caption = 'Gosu Tutorial Game'

    @debug_dialog = DebugDialog.new(window: self)

    @gameplay = Gameplay.new(window_width: WIDTH, window_height: HEIGHT)

    @input = Input.new(actors: @gameplay.actors)

    @presentation = Presentation.new(models: @gameplay.objects)
    @debug_presentation = DebugPresentation.new(
      models: @gameplay.objects, window_width: WIDTH, window_height: HEIGHT
    )
  end

  def update
    if Gosu.button_down? Gosu::KbQ
      # shut down
      @input.destroy
      exit 0
    else
      # keep running
      @debug_dialog.update

      commands = @input.commands
      @gameplay.update(commands: commands, update_interval: update_interval)
    end
  end

  def draw
    @debug_dialog.draw
    @presentation.draw
    @debug_presentation.draw if @debug
  end

  def enable_debug!
    @debug = true
  end
end

window = GameWindow.new
window.show
