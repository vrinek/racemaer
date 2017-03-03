# Records input from its delegate to a file
class InputRecorder
  COMMANDS_FILENAME = File.expand_path('../../commands.rbm', __FILE__)

  def initialize(delegate:)
    @delegate = delegate
    @commands_buffer = []
  end

  def destroy
    store_commands_buffer(@commands_buffer)
  end

  def commands
    cmds = @delegate.commands
    @commands_buffer << cmds
    cmds
  end

  private

  def store_commands_buffer(buffer)
    File.open(COMMANDS_FILENAME, 'w') do |file|
      Marshal.dump(buffer, file)
    end
  end
end
