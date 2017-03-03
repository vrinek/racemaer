require 'json'

require 'chipmunk'
require 'gosu'

require_relative './src/gameplay.rb'
require_relative './src/human_input.rb'
require_relative './src/human_presenter.rb'

require_relative './src/debug_presenter.rb'
require_relative './src/sensor_presenter.rb'
require_relative './src/debug_dialog.rb'
require_relative './src/input_recorder.rb'
require_relative './src/input_replayer.rb'

# Main game window
class GameWindow < Gosu::Window
  WIDTH = 1280
  HEIGHT = 768

  def initialize
    @debug = false # true / false
    @mode = nil # :record / :replay / nil

    super(WIDTH, HEIGHT)
    self.caption = 'Gosu Tutorial Game'

    @debug_dialog = DebugDialog.new(window: self)

    @gameplay = Gameplay.new(world_width: WIDTH, world_height: HEIGHT)

    human_input = HumanInput.new(actors: @gameplay.actors)

    @input = case @mode
             when :record
               InputRecorder.new(delegate: human_input)
             when :replay
               InputReplayer.new(delegate: human_input)
             else
               human_input
             end

    @human_presenter = HumanPresenter.new(models: @gameplay.objects)
    @debug_presenter = DebugPresenter.new(
      models: @gameplay.objects, window_width: WIDTH, window_height: HEIGHT
    )

    @sensor_presenter = SensorPresenter.new(models: @gameplay.objects, space: @gameplay.space)
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
    @human_presenter.draw
    @debug_presenter.draw if @debug
    @sensor_presenter.draw
  end

  def enable_debug!
    @debug = true
  end
end

window = GameWindow.new
window.show
