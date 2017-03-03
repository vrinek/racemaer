require_relative './interfaced_array.rb'
require_relative './interface/presenter.rb'

require_relative './sensor_presenter/car_sensors.rb'

# Presenter component to provide AI with sensors
class SensorPresenter
  PRESENTERS = {
    'Car' => CarSensors
  }.freeze

  LOG_FILENAME = File.expand_path('../../sensors.rbm', __FILE__)

  attr_reader :log

  def initialize(models:, space:)
    @presenters = InterfacedArray.new(interface: Presenter)
    models.each do |model|
      presenter_class = PRESENTERS[model.class.to_s]
      next unless presenter_class
      @presenters << presenter_class.new(model: model, space: space)
    end

    @log = []
  end

  def debug_draw
    @presenters.each(&:debug_draw)
  end

  def draw
    @log << @presenters.map(&:draw)
  end

  def destroy
    # TODO: move to own class like InputRecorder
    File.open(LOG_FILENAME, 'w') do |file|
      Marshal.dump(@log, file)
    end
  end
end
