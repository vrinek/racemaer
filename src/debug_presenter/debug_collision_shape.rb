# Draws a debug view of a collision shape
class DebugCollisionShape
  Z_ORDER = 11

  CIRCLE_STEPS = 12
  DEGREES_PER_STEP = 360.0 / CIRCLE_STEPS

  attr_reader :collision_shape

  def initialize(collision_shape)
    @collision_shape = collision_shape
  end

  def draw
    if collision_shape.is_a?(CP::Shape::Poly)
      draw_polygon
    elsif collision_shape.is_a?(CP::Shape::Circle)
      draw_circle
    elsif collision_shape.is_a?(CP::Shape::Segment)
      draw_segment
    else
      puts "I don't know how to draw #{collision_shape.class}"
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
    collision_shape.num_verts.times do |index|
      start = polygon_side_edge(index)
      finish = polygon_side_edge(index + 1)

      Gosu.draw_line(
        start.x, start.y, color,
        finish.x, finish.y, color,
        Z_ORDER
      )
    end
  end

  def polygon_side_edge(index)
    index = 0 if index >= collision_shape.num_verts
    rigid_body.pos + collision_shape.vert(index).rotate(direction_vector)
  end

  def draw_segment
    Gosu.draw_line(
      segment_start.x, segment_start.y, color,
      segment_finish.x, segment_finish.y, color,
      Z_ORDER
    )
  end

  def segment_start
    rigid_body.pos + collision_shape.a.rotate(direction_vector)
  end

  def segment_finish
    rigid_body.pos + collision_shape.b.rotate(direction_vector)
  end

  def draw_circle
    radius = collision_shape.radius
    CIRCLE_STEPS.times do |side_number|
      start = circle_side_edge(radius, side_number)
      finish = circle_side_edge(radius, side_number + 1)

      Gosu.draw_line(
        start.x, start.y, color,
        finish.x, finish.y, color,
        Z_ORDER
      )
    end
  end

  def circle_side_edge(radius, side_number)
    angle = (DEGREES_PER_STEP * side_number).gosu_to_radians
    edge_offset = CP::Vec2.new(radius, 0).rotate(CP::Vec2.for_angle(angle))
    rigid_body.pos + edge_offset
  end
end
