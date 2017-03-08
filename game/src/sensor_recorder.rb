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
    File.open(LOG_FILENAME, 'w') do |file|
      log.each { |line| file.puts(line.to_csv) }
    end
  end
end
