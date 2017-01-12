require_relative './debug_collision_shape.rb'

# Loose tire. Mostly used for debugging purposes.
class LooseTire
  Z_ORDER = 5
  SPRITE_SCALE = 0.5

  attr_reader :rigid_body, :collision_shape
  attr_reader :sprite

  def initialize(x:, y:, space:)
    @sprite = Gosu::Image.new('assets/Objects/tires_red.png')

    @rigid_body = CP::Body.new(0.1, 1)
    rigid_body.pos.x = x
    rigid_body.pos.y = y

    radius = sprite.width / 2 * SPRITE_SCALE
    @collision_shape = CP::Shape::Circle.new(rigid_body, radius, CP::Vec2::ZERO)

    space.add_body(rigid_body)
    space.add_shape(collision_shape)
  end

  def update(commands:)
    # nothing yet
  end

  def draw(debug: false)
    sprite.draw_rot(x, y, Z_ORDER, rigid_body.a.radians_to_gosu, 0.5, 0.5, SPRITE_SCALE, SPRITE_SCALE)

    return unless debug
    DebugCollisionShape.new(collision_shape).draw
  end

  private

  def x
    rigid_body.pos.x
  end

  def y
    rigid_body.pos.y
  end
end
