class InputRecorder
  COMMANDS_FILENAME = File.expand_path('../../commands.rbm', __FILE__)

  def initialize(delegate:, mode: nil)
    @delegate = delegate
    @mode = mode
    initialize_commands_buffer
  end

  def destroy
    store_commands_buffer(@commands_buffer) if @mode == :record
  end

  def commands
    case @mode
    when :record
      cmds = @delegate.commands
      @commands_buffer << cmds
      cmds
    when :replay
      @commands_buffer.shift || []
    else
      @delegate.commands
    end
  end

  private

  def initialize_commands_buffer
    @commands_buffer = case @mode
                       when :replay
                         load_commands_buffer
                       else
                         []
                       end
  end

  def store_commands_buffer(buffer)
    File.open(COMMANDS_FILENAME, 'w') do |file|
      Marshal.dump(buffer, file)
    end
  end

  def load_commands_buffer
    File.open(COMMANDS_FILENAME, 'r') do |file|
      Marshal.load(file)
    end
  end
end
