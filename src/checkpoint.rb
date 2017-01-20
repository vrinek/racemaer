require_relative './debug_collision_shape.rb'
require_relative './track.rb'

# A single checkpoint on the map
class Checkpoint
  attr_reader :trigger_shape

  def self.new_with(map:, static_body:, space:)
    checkpoints = []

    map['checkpoints'].each_with_index do |(start, finish), index|
      is_flag = index == map['flag_index']
      checkpoint = Checkpoint.new(
        from: start, to: finish, static_body: static_body
      )
      checkpoint.trigger_shape.object = { is_flag: is_flag }
      checkpoints << checkpoint
    end

    checkpoints.each { |checkpoint| space.add_shape(checkpoint.trigger_shape) }

    checkpoints
  end

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
