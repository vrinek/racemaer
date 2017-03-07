require 'csv'

require_relative './sensor_presenter/car_sensors.rb'

# Records sensors from its delegate to a file
class SensorRecorder
  LOG_FILENAME = File.expand_path('../../sensors.csv', __FILE__)

  def initialize(delegate:)
    @delegate = delegate
    @log = []
  end

  def draw
    readings = @delegate.draw
    @log << readings
    readings
  end

  def destroy
    store_log(@log)
  end

  private

  def store_log(log)
    data = normalize_log(log)

    File.open(LOG_FILENAME, 'w') do |file|
      data.each { |line| file.puts(line.to_csv) }
    end
  end

  def normalize_log(log)
    max_linear_velocity = log.map { |l| l[0] }.max
    max_lateral_velocity = log.map { |l| l[1] }.max

    log.map do |line|
      linear_velocity = max_linear_velocity.zero? ? 0 : line.shift / max_linear_velocity.to_f
      lateral_velocity = max_lateral_velocity.zero? ? 0 : line.shift / max_lateral_velocity.to_f
      sensors = line.map { |s| s / CarSensors::MAX_RADIUS }
      [linear_velocity, lateral_velocity, *sensors].map { |n| n.round(3) }
    end
  end
end
