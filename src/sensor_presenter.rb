require_relative './interfaced_array.rb'
require_relative './interface/presenter.rb'

require_relative './sensor_presenter/car_sensors.rb'

class SensorPresenter
  PRESENTERS = {
    'Car' => CarSensors
  }.freeze

  def initialize(models:, space:)
    @presentations = InterfacedArray.new(interface: Presenter)
    models.each do |model|
      presenter_class = PRESENTERS[model.class.to_s]
      next unless presenter_class
      @presentations << presenter_class.new(model: model, space: space)
    end
  end

  def draw
    @presentations.each(&:draw)
  end
end
