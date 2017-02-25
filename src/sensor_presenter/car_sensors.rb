require_relative '../debug_presenter/debug_collision_shape.rb'

class CarSensors
  RADIUS_MULTIPLIER = 10
  RADIUS_STEPS = 5
  CIRCLE_STEPS = 8
  DEGREES_PER_STEP = 360.0 / CIRCLE_STEPS

  class SensorHandler
    def initialize(contacts:)
      @contacts = contacts
    end

    def begin(arbiter)
      sensor_id = arbiter.shapes.first.object[:id]
      @contacts[sensor_id] = true
    end

    def separate(arbiter)
      sensor_id = arbiter.shapes.first.object[:id]
      @contacts[sensor_id] = false
    end
  end

  def initialize(model:, space:)
    @sensor_shapes = []
    @contacts = {}

    CIRCLE_STEPS.times do |side_number|
      RADIUS_STEPS.times do |distance|
        id = "#{side_number}-#{distance}"
        short = 2**distance * RADIUS_MULTIPLIER
        long = 2**(distance + 1) * RADIUS_MULTIPLIER

        shape = init_sensor_shape(model.rigid_body, short, long, side_number)
        shape.object = { id: id }
        @sensor_shapes << shape
        @contacts[id] = false
      end
    end

    @sensor_shapes.each { |shape| space.add_shape(shape) }

    @debug_sensor_shapes = @sensor_shapes.map { |shape| DebugCollisionShape.new(shape) }

    space.add_collision_handler(:car_sensor, :track_barrier, SensorHandler.new(contacts: @contacts))
  end

  def draw
    @debug_sensor_shapes.each(&:draw)
  end

  def sensors
    @contacts.values.map { |b| b ? '1' : '0' }.join
  end

  private

  def init_sensor_shape(body, short, long, side_number)
    verts = [
      circle_side_edge(short, side_number),
      circle_side_edge(short, side_number + 1),
      circle_side_edge(long, side_number + 1),
      circle_side_edge(long, side_number)
    ]

    sensor_shape = CP::Shape::Poly.new(body, verts, CP::Vec2::ZERO)
    sensor_shape.sensor = true
    sensor_shape.collision_type = :car_sensor

    sensor_shape
  end

  def circle_side_edge(radius, side_number)
    angle = (DEGREES_PER_STEP * side_number).gosu_to_radians
    CP::Vec2.new(radius, 0).rotate(CP::Vec2.for_angle(angle))
  end
end
