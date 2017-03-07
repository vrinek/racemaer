require 'csv'

# Records input from its delegate to a file
class InputRecorder
  COMMANDS_FILENAME = File.expand_path('../../commands.csv', __FILE__)

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
    data = normalize_commands_buffer(buffer)

    File.open(COMMANDS_FILENAME, 'w') do |file|
      data.each { |line| file.puts(line.to_csv) }
    end
  end

  def normalize_commands_buffer(buffer)
    buffer.map do |cmds|
      actions = cmds.map { |cmd| cmd[:action] }
      [
        actions.include?(:accelerate) ? 1 : 0,
        actions.include?(:turn_left) ? 1 : 0,
        actions.include?(:turn_right) ? 1 : 0,
        actions.include?(:brake) ? 1 : 0
      ]
    end
  end
end
