require_relative './interfaced_array.rb'
require_relative './interface/presenter.rb'

require_relative './sensor_presenter/car_sensors.rb'

# Presenter component to provide AI with sensors
class SensorPresenter
  PRESENTERS = {
    'Car' => CarSensors
  }.freeze

  def initialize(models:, space:)
    @presenters = InterfacedArray.new(interface: Presenter)
    models.each do |model|
      presenter_class = PRESENTERS[model.class.to_s]
      next unless presenter_class
      @presenters << presenter_class.new(model: model, space: space)
    end
  end

  def debug_draw
    @presenters.each(&:debug_draw)
  end

  def draw
    @presenters.map(&:draw).flatten
  end

  def destroy; end
end
