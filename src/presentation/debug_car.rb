class DebugCar
  def initialize(model:)
    @model = model
  end

  def draw
    DebugDirection.new(@model.rigid_body).draw
    DebugCollisionShape.new(@model.collision_shape).draw
  end
end
