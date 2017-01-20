require_relative '../debug_collision_shape.rb'

# 2D debug representation of a single checkpoint
class DebugCheckpoint
  def initialize(model:)
    @debug_collision_shape = DebugCollisionShape.new(model.trigger_shape)
  end

  def draw
    @debug_collision_shape.draw
  end
end
