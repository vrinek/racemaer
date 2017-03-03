# Replays input from its delegate to a file
class InputReplayer
  COMMANDS_FILENAME = File.expand_path('../../commands.rbm', __FILE__)

  def initialize(delegate:)
    @delegate = delegate
    @commands_buffer = load_commands_buffer
  end

  def destroy; end

  def commands
    @commands_buffer.shift || []
  end

  private

  def load_commands_buffer
    File.open(COMMANDS_FILENAME, 'r') do |file|
      Marshal.load(file)
    end
  end
end
