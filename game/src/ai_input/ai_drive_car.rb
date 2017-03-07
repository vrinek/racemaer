require 'matrix'

# AI to drive the car based on a pre-trained NN
class AIDriveCar
  # TODO: Threshold should be taken into account in the loss function when training
  THRESHOLD = 0.4

  def initialize(actor_id:, sensors:, params:)
    @actor_id = actor_id
    @sensors = sensors
    @weight = Matrix[*params['W']]
    @bias = Matrix[params['b']]
  end

  def commands
    cmds = []
    cmds << accelerate if accelerate?
    cmds << turn_left  if turn_left?
    cmds << turn_right if turn_right?
    cmds << brake      if brake?
    cmds
  end

  private

  def sigmoid(x)
    1.0 / (1 + Math::E**-x)
  end

  def labels
    features = Matrix[@sensors.draw]

    (features * @weight + @bias).to_a.flatten.map { |i| sigmoid(i) }
  end

  def accelerate?
    labels[0] > THRESHOLD
  end

  def turn_left?
    labels[1] > THRESHOLD
  end

  def turn_right?
    labels[2] > THRESHOLD
  end

  def brake?
    labels[3] > THRESHOLD
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
