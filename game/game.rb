require 'json'

require 'chipmunk'
require 'gosu'
require 'ruby-prof'

require_relative './src/gameplay.rb'
require_relative './src/human_input.rb'
require_relative './src/human_presenter.rb'

require_relative './src/ai_input.rb'

require_relative './src/debug_presenter.rb'
require_relative './src/sensor_presenter.rb'
require_relative './src/debug_dialog.rb'
require_relative './src/input_recorder.rb'
require_relative './src/input_replayer.rb'

PROFILING = false

# Main game window
class GameWindow < Gosu::Window
  WIDTH = 1280
  HEIGHT = 768

  def initialize
    RubyProf.start if PROFILING

    @debug = false # true / false
    @mode = ARGV[0] # 'record' / 'replay' / 'ai' / nil

    super(WIDTH, HEIGHT)
    self.caption = 'Racer Maker'

    @debug_dialog = DebugDialog.new(window: self)

    @gameplay = Gameplay.new(world_width: WIDTH, world_height: HEIGHT)

    @human_presenter = HumanPresenter.new(models: @gameplay.objects)
    @debug_presenter = DebugPresenter.new(
      models: @gameplay.objects, window_width: WIDTH, window_height: HEIGHT
    )

    @sensor_presenter = SensorPresenter.new(
      models: @gameplay.objects, space: @gameplay.space, mode: @mode
    )

    @input = initialize_input(@gameplay.actors, @mode, @sensor_presenter)
  end

  def update
    if Gosu.button_down? Gosu::KbQ
      # shut down
      @input.destroy
      @sensor_presenter.destroy

      if PROFILING
        result = RubyProf.stop

        printer = RubyProf::FlatPrinter.new(result)
        printer.print(STDOUT)
      end

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
    @sensor_presenter.debug_draw if @debug
  end

  def enable_debug!
    @debug = true
  end

  private

  def initialize_input(actors, mode, sensor_presenter)
    human_input = HumanInput.new(actors: actors)

    case mode
    when 'record'
      InputRecorder.new(delegate: human_input)
    when 'replay'
      InputReplayer.new
    when 'ai'
      AiInput.new(actors: actors, sensors: sensor_presenter)
    else
      human_input
    end
  end
end

window = GameWindow.new
window.show
