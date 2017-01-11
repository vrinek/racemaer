require_relative './debug_collision_shape.rb'
require_relative './track.rb'

# A single checkpoint on the map
class Checkpoint
  attr_reader :trigger_shape

  def initialize(from:, to:, static_body:)
    vec1 = CP::Vec2.new(*from.map { |n| n * Track::TILE_SIZE })
    vec2 = CP::Vec2.new(*to.map { |n| n * Track::TILE_SIZE })

    @trigger_shape = CP::Shape::Segment.new(static_body, vec1, vec2, 10)
    trigger_shape.sensor = true
    trigger_shape.collision_type = :checkpoint
  end

  def update
    # noop
  end

  def draw(debug: false)
    return unless debug
    DebugCollisionShape.new(trigger_shape).draw
  end
end
