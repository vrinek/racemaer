# Draws a debug view of the direction of a rigid body
class DebugDirection
  Z_ORDER = 11
  COLOR = Gosu::Color::WHITE

  attr_reader :rigid_body

  def initialize(rigid_body)
    @rigid_body = rigid_body
  end

  def draw
    start = rigid_body.pos
    finish = start + direction_vector * 50

    Gosu.draw_line(
      start.x, start.y, COLOR,
      finish.x, finish.y, COLOR,
      Z_ORDER
    )
  end

  private

  def direction_vector
    CP::Vec2.for_angle(rigid_body.a)
  end
end
