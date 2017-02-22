require_relative './interfaced_array.rb'
require_relative './interface/commander.rb'

require_relative './input/drive_car.rb'

class Input
  COMMANDS_FILENAME = File.expand_path('../../commands.rbm', __FILE__)

  COMMANDERS = {
    'Car' => DriveCar
  }.freeze

  def initialize(actors:, mode: nil)
    @mode = mode
    initialize_commands_buffer
    @commanders = InterfacedArray.new(interface: Commander)

    actors.each do |actor_id, actor|
      commander_class = COMMANDERS[actor.class.to_s]
      fail "Unknown actor class #{actor.class}" unless commander_class
      @commanders << commander_class.new(actor_id: actor_id)
    end
  end

  def destroy
    store_commands_buffer(@commands_buffer) if @mode == :record
  end

  def commands
    case @mode
    when :record
      cmds = @commanders.map(&:commands).flatten
      @commands_buffer << cmds
      cmds
    when :replay
      @commands_buffer.shift || []
    else
      @commanders.map(&:commands).flatten
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
