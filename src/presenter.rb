require_relative './interfaced_array.rb'
require_relative './interface/presenter.rb'

require_relative './presentation/present_track.rb'
require_relative './presentation/present_car.rb'
require_relative './presentation/present_loose_tire.rb'

# Presenter component for a human to play the game
class HumanPresenter
  PRESENTERS = {
    'Car' => PresentCar,
    'LooseTire' => PresentLooseTire,
    'Track' => PresentTrack
  }.freeze

  def initialize(models:)
    @presentations = InterfacedArray.new(interface: Presenter)
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
