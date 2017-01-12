require_relative '../debug_collision_shape.rb'
require_relative '../debug_direction.rb'

# 2D debug presentaion of the car
class DebugCar
  def initialize(model:)
    @debug_direction = DebugDirection.new(model.rigid_body)
    @debug_collision_shape = DebugCollisionShape.new(model.collision_shape)
  end

  def draw
    @debug_direction.draw
    @debug_collision_shape.draw
  end
end
