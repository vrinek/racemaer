# Loose tire. Mostly used for debugging purposes.
class LooseTire
  RADIUS = 14

  attr_reader :rigid_body, :collision_shape

  def initialize(x:, y:, space:)
    @rigid_body = CP::Body.new(0.1, 1)
    rigid_body.pos.x = x
    rigid_body.pos.y = y

    @collision_shape = CP::Shape::Circle.new(rigid_body, RADIUS, CP::Vec2::ZERO)

    space.add_body(rigid_body)
    space.add_shape(collision_shape)
  end

  def update(commands:)
    # nothing yet
  end

  def presentation_view
    {
      x: rigid_body.pos.x,
      y: rigid_body.pos.y,
      angle: rigid_body.a.radians_to_gosu
    }
  end
end
