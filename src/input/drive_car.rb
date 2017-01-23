# Input commands for driving a car
class DriveCar
  def initialize(actor_id:)
    @actor_id = actor_id
  end

  def commands
    cmds = []
    cmds << turn_left  if Gosu.button_down? Gosu::KbLeft
    cmds << turn_right if Gosu.button_down? Gosu::KbRight
    cmds << accelerate if Gosu.button_down? Gosu::KbUp
    cmds << brake      if Gosu.button_down? Gosu::KbDown
    cmds
  end

  private

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
