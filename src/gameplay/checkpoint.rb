# A single checkpoint on the map
class Checkpoint
  attr_reader :trigger_shape

  def self.new_with(map:, space:)
    static_body = CP::StaticBody.new
    checkpoints = map['checkpoints'].map do |(start, finish)|
      Checkpoint.new(
        from: start, to: finish, static_body: static_body, tilesize: map['tilesize']
      )
    end

    checkpoints[map['flag_index']].trigger_shape.object[:is_flag] = true
    checkpoints.each { |checkpoint| space.add_shape(checkpoint.trigger_shape) }

    checkpoints
  end

  def initialize(from:, to:, static_body:, tilesize:)
    vec1 = CP::Vec2.new(*from.map { |n| n * tilesize })
    vec2 = CP::Vec2.new(*to.map { |n| n * tilesize })

    @trigger_shape = CP::Shape::Segment.new(static_body, vec1, vec2, 10)
    trigger_shape.sensor = true
    trigger_shape.collision_type = :checkpoint
    trigger_shape.object = { is_flag: false }
  end

  def update(commands:)
    # noop
  end

  def draw(debug: false)
    # noop
  end
end
