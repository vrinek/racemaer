require_relative '../debug_presenter/debug_collision_shape.rb'

# Sensors array for a Car
class CarSensors
  RADIUS_MULTIPLIER = 10
  RADIUS_STEPS = 5
  CIRCLE_STEPS = 8
  DEGREES_PER_STEP = 360.0 / CIRCLE_STEPS

  # Collision handler for "collision" of car sensor with track barrier
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
    @sensor_shapes = initialize_sensor_array(model.rigid_body)
    @sensor_shapes.each { |shape| space.add_shape(shape) }

    @contacts = {}
    @sensor_shapes.each { |shape| @contacts[shape.object[:id]] = false }

    # TODO: move to own class
    @debug_sensor_shapes = @sensor_shapes.map { |shape| DebugCollisionShape.new(shape) }

    space.add_collision_handler(:car_sensor, :track_barrier, SensorHandler.new(contacts: @contacts))
  end

  def debug_draw
    @debug_sensor_shapes.each(&:draw)
  end

  def draw
    @contacts.values.map { |b| b ? '1' : '0' }.join
  end

  private

  # Initializes all the sensors of the Car (they will be RADIUS_STEPS x CIRCLE_STEPS sensors)
  def initialize_sensor_array(rigid_body)
    shapes = []

    RADIUS_STEPS.times do |distance|
      short = 2**distance * RADIUS_MULTIPLIER
      long = 2**(distance + 1) * RADIUS_MULTIPLIER

      shapes += initialize_sensor_circle(rigid_body, short, long)
    end

    shapes
  end

  # Initializes sensors in a set distance (they will be CIRCLE_STEPS sensors)
  def initialize_sensor_circle(rigid_body, short, long)
    shapes = []

    CIRCLE_STEPS.times do |side_number|
      id = "#{side_number}-#{short}"

      shape = initialize_sensor(rigid_body, short, long, side_number)
      shape.object = { id: id }
      shapes << shape
    end

    shapes
  end

  # Initializes one sensor as a collision shape
  def initialize_sensor(rigid_body, short, long, side_number)
    verts = [
      circle_side_edge(short, side_number),
      circle_side_edge(short, side_number + 1),
      circle_side_edge(long, side_number + 1),
      circle_side_edge(long, side_number)
    ]

    sensor_shape = CP::Shape::Poly.new(rigid_body, verts, CP::Vec2::ZERO)
    sensor_shape.sensor = true
    sensor_shape.collision_type = :car_sensor

    sensor_shape
  end

  # Calculates the position of an edge of a circle
  def circle_side_edge(radius, side_number)
    angle = (DEGREES_PER_STEP * side_number).gosu_to_radians
    CP::Vec2.new(radius, 0).rotate(CP::Vec2.for_angle(angle))
  end
end
