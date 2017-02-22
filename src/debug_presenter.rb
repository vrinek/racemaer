require_relative './interfaced_array.rb'
require_relative './interface/presenter.rb'

require_relative './presentation/debug_car.rb'
require_relative './presentation/debug_checkpoint.rb'
require_relative './presentation/debug_loose_tire.rb'
require_relative './presentation/debug_track.rb'

# Presenter component for debugging
class DebugPresenter
  PRESENTERS = {
    'Car' => DebugCar,
    'Checkpoint' => DebugCheckpoint,
    'LooseTire' => DebugLooseTire,
    'Track' => DebugTrack
  }

  def initialize(models:, window_width:, window_height:)
    @window_width = window_width
    @window_height = window_height

    @presentations = InterfacedArray.new(interface: Presenter)
    models.each do |model|
      presenter_class = PRESENTERS[model.class.to_s]
      next unless presenter_class
      @presentations << presenter_class.new(model: model)
    end
  end

  def draw
    @presentations.each(&:draw)

    color = Gosu::Color.rgba(0, 0, 0, 128)
    Gosu.draw_rect(0, 0, @window_width, @window_height, color, 10)
  end
end
