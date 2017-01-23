require_relative './interfaced_array.rb'
require_relative './interface/presentation.rb'

require_relative './presentation/debug_car.rb'
require_relative './presentation/debug_checkpoint.rb'
require_relative './presentation/debug_loose_tire.rb'
require_relative './presentation/debug_track.rb'

# Presentation component for debugging
class DebugPresentation
  PRESENTERS = {
    'Car' => DebugCar,
    'Checkpoint' => DebugCheckpoint,
    'LooseTire' => DebugLooseTire,
    'Track' => DebugTrack
  }

  def initialize(models:)
    @presentations = InterfacedArray.new(interface: Presentation)
    models.each do |model|
      presenter_class = PRESENTERS[model.class.to_s]
      next unless presenter_class
      @presentations << presenter_class.new(model: model)
    end
  end

  def draw
    @presentations.each(&:draw)
  end
end
