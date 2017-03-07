# Records sensors from its delegate to a file
class SensorRecorder
  LOG_FILENAME = File.expand_path('../../sensors.rbm', __FILE__)

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
    File.open(LOG_FILENAME, 'w') do |file|
      Marshal.dump(@log, file)
    end
  end
end
