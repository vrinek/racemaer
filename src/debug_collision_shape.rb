# Draws a debug view of a collision shape
class DebugCollisionShape
  Z_ORDER = 11

  attr_reader :collision_shape

  def initialize(collision_shape)
    @collision_shape = collision_shape
  end

  def draw
    if collision_shape.is_a?(CP::Shape::Poly)
      draw_polygon
    elsif collision_shape.is_a?(CP::Shape::Circle)
      draw_circle
    end
  end

  private

  def color
    if rigid_body.static?
      Gosu::Color::GREEN
    else
      Gosu::Color::CYAN
    end
  end

  def rigid_body
    collision_shape.body
  end

  def direction_vector
    CP::Vec2.for_angle(rigid_body.a)
  end

  def draw_polygon
    num_verts = collision_shape.num_verts
    num_verts.times do |index|
      next_index = num_verts == index + 1 ? 0 : index + 1
      next_vert = collision_shape.vert(next_index)

      start = rigid_body.pos + collision_shape.vert(index).rotate(direction_vector)
      finish = rigid_body.pos + next_vert.rotate(direction_vector)

      Gosu.draw_line(
        start.x, start.y, color,
        finish.x, finish.y, color,
        Z_ORDER
      )
    end
  end

  def draw_circle
    radius = collision_shape.radius
    steps = 20
    degrees_step = 360.0 / steps
    steps.times do |side|
      angle = (rigid_body.a.radians_to_gosu + (degrees_step * side)).gosu_to_radians
      next_angle = (rigid_body.a.radians_to_gosu + (degrees_step * (side + 1))).gosu_to_radians
      offset = CP::Vec2.new(radius, 0).rotate(CP::Vec2.for_angle(angle))
      next_offset = CP::Vec2.new(radius, 0).rotate(CP::Vec2.for_angle(next_angle))
      start = rigid_body.pos + offset
      finish = rigid_body.pos + next_offset

      Gosu.draw_line(
        start.x, start.y, color,
        finish.x, finish.y, color,
        Z_ORDER
      )
    end
  end
end
