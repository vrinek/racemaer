require 'matrix'

class AIDriveCar
  # TODO: Threshold should be taken into account in the loss function
  THRESHOLD = 0.4

  def initialize(actor_id:, sensors:, params:)
    @actor_id = actor_id
    @sensors = sensors
    @weight = Matrix[*params['W']]
    @bias = Matrix[params['b']]
  end

  def commands
    cmds = []
    cmds << accelerate if out[0] > THRESHOLD
    cmds << turn_left  if out[1] > THRESHOLD
    cmds << turn_right if out[2] > THRESHOLD
    cmds << brake      if out[3] > THRESHOLD
    # p cmds.map { |e| e[:action] }
    cmds
  end

  private

  def sigmoid(x)
    1.0 / (1 + Math::E**-x)
  end

  def out
    input = Matrix[@sensors.draw]

    (input * @weight + @bias).to_a.flatten.map { |i| sigmoid(i) }
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
