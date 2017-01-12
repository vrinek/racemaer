require_relative '../debug_collision_shape.rb'
require_relative '../debug_direction.rb'

# 2D debug presentaion of the car
class DebugCar
  def initialize(model:)
    @model = model
  end

  def draw
    DebugDirection.new(@model.rigid_body).draw
    DebugCollisionShape.new(@model.collision_shape).draw
  end
end
