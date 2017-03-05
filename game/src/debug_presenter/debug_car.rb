require_relative './debug_collision_shape.rb'
require_relative './debug_direction.rb'

# 2D debug presentation of the car
class DebugCar
  def initialize(model:)
    @debug_direction = DebugDirection.new(model.rigid_body, &:rot)
    @debug_velocity = DebugDirection.new(model.rigid_body) do |body|
      body.v.unrotate(body.rot) / 50
    end
    @debug_collision_shape = DebugCollisionShape.new(model.collision_shape)
  end

  def draw
    @debug_direction.draw
    @debug_velocity.draw
    @debug_collision_shape.draw
  end
end
