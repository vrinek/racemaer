# Replays input from a file
class InputReplayer
  COMMANDS_FILENAME = File.expand_path('../../commands.csv', __FILE__)

  def initialize
    # TODO: Avoid hardcoded actor_id
    @actor_id = :car_1

    @commands_buffer = load_commands_buffer
  end

  def destroy; end

  def commands
    @commands_buffer.shift || []
  end

  private

  def load_commands_buffer
    data = CSV.read(COMMANDS_FILENAME)
    data.map do |row|
      cmds = []
      cmds << accelerate if accelerate?(row)
      cmds << turn_left  if turn_left?(row)
      cmds << turn_right if turn_right?(row)
      cmds << brake      if brake?(row)
      cmds
    end
  end

  def accelerate?(row)
    row[0] == '1'
  end

  def turn_left?(row)
    row[1] == '1'
  end

  def turn_right?(row)
    row[2] == '1'
  end

  def brake?(row)
    row[3] == '1'
  end

  def turn_left
    { action: :turn_left, actor_id: @actor_id }
  end

  def turn_right
    { action: :turn_right, actor_id: @actor_id }
  end

  def accelerate
    { action: :accelerate, actor_id: @actor_id }
  end

  def brake
    { action: :brake, actor_id: @actor_id }
  end
end
