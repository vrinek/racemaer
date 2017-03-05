# Draws a debug view of the direction of a rigid body
class DebugDirection
  Z_ORDER = 11
  COLOR = Gosu::Color::WHITE

  attr_reader :rigid_body

  def initialize(rigid_body, &block)
    @rigid_body = rigid_body
    @block = block
  end

  def draw
    start = rigid_body.pos
    finish = start + @block.yield(rigid_body) * 50

    Gosu.draw_line(
      start.x, start.y, COLOR,
      finish.x, finish.y, COLOR,
      Z_ORDER
    )
  end
end
