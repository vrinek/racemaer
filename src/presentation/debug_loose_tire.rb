require_relative '../debug_collision_shape.rb'

class DebugLooseTire
  def initialize(model:)
    @model = model
  end

  def draw
    DebugCollisionShape.new(@model.collision_shape).draw
  end
end
