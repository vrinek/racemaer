class DebugDistanceSensor
  Z_ORDER = 11
  COLOR = Gosu::Color.new(120, 230, 130, 0)

  def initialize(distances, rigid_body)
    @distances = distances
    @degrees_per_step = 360.0 / distances.length
    @rigid_body = rigid_body
  end

  def draw
    @distances.each do |index, value|
      sides = [
        circle_side_edge(0, index.to_i),
        circle_side_edge(0, index.to_i + 1),
        circle_side_edge(value, index.to_i + 1),
        circle_side_edge(value, index.to_i)
      ]

      Gosu.draw_quad(
        sides[0].x, sides[0].y, COLOR,
        sides[1].x, sides[1].y, COLOR,
        sides[2].x, sides[2].y, COLOR,
        sides[3].x, sides[3].y, COLOR,
        Z_ORDER
      )
    end
  end

  def circle_side_edge(radius, side_number)
    angle = (@degrees_per_step * (side_number + 0.5)).gosu_to_radians
    side = CP::Vec2.new(radius, 0).rotate(CP::Vec2.for_angle(angle))
    @rigid_body.pos + side.rotate(@rigid_body.rot)
  end
end
