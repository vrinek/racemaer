require 'chipmunk'

require_relative '../debug_presenter/debug_collision_shape.rb'
require_relative '../debug_presenter/debug_distance_sensor.rb'

# Sensors array for a Car
class CarSensors
  RADIUS_MULTIPLIER = 15
  RADIUS_POWER_BASE = 1.1
  RADIUS_STEPS = 45
  CIRCLE_STEPS = 36

  DEGREES_PER_STEP = 360.0 / CIRCLE_STEPS
  MAX_RADIUS = RADIUS_POWER_BASE**RADIUS_STEPS * RADIUS_MULTIPLIER
  SENSOR_LOSS = 0.8

  MAX_LINEAR_VELOCITY = 450.0
  MAX_LATERAL_VELOCITY = 100.0

  # Collision handler for "collision" of car sensor with track barrier
  class SensorHandler
    def initialize(contacts:)
      @contacts = contacts
    end

    def pre_solve(arbiter)
      object = arbiter.shapes.first.object
      @contacts[object[:side_number]][object[:distance]] = 1.0
      true
    end
  end

  def initialize(model:, space:)
    @sensor_shapes = initialize_sensor_array(model.rigid_body)
    @body = model.rigid_body
    @sensor_shapes.each { |shape| space.add_shape(shape) }

    @contacts = {}
    @sensor_shapes.each do |shape|
      @contacts[shape.object[:side_number]] ||= {}
      @contacts[shape.object[:side_number]][shape.object[:distance]] = 0.0
    end
    @distances = {}
    update_distances

    # TODO: move to own class
    @debug_sensor_shapes = @sensor_shapes.map do |shape|
      DebugCollisionShape.new(shape)
    end
    @debug_distance_sensor = DebugDistanceSensor.new(@distances, @body)

    space.add_collision_handler(:car_sensor, :track_barrier, SensorHandler.new(contacts: @contacts))
  end

  def debug_draw
    @debug_sensor_shapes.each(&:draw)
    @debug_distance_sensor.draw
  end

  def draw
    readings = []

    vel = @body.v.unrotate(@body.rot)
    readings << vel.x.round(3)
    readings << vel.y.round(3)

    update_distances
    readings += @distances.values.map { |v| v.round(2) }

    @contacts.each do |side_number, side_contacts|
      side_contacts.each_key do |distance|
        @contacts[side_number][distance] *= SENSOR_LOSS
      end
    end

    normalize(readings)
  end

  private

  def update_distances
    @contacts.each do |side_number, side_contacts|
      distance = side_contacts.keys.find { |d| side_contacts[d] > 0.2 }
      @distances[side_number] = distance || MAX_RADIUS
    end
  end

  # Initializes all the sensors of the Car (they will be RADIUS_STEPS x CIRCLE_STEPS sensors)
  def initialize_sensor_array(rigid_body)
    shapes = []

    RADIUS_STEPS.times do |distance|
      short = RADIUS_POWER_BASE**distance * RADIUS_MULTIPLIER
      long = RADIUS_POWER_BASE**(distance + 1) * RADIUS_MULTIPLIER

      shapes += initialize_sensor_circle(rigid_body, short, long)
    end

    shapes
  end

  # Initializes sensors in a set distance (they will be CIRCLE_STEPS sensors)
  def initialize_sensor_circle(rigid_body, short, long)
    shapes = []

    CIRCLE_STEPS.times do |side_number|
      shape = initialize_sensor(rigid_body, short, long, side_number + 0.5)
      shape.object = { side_number: side_number, distance: short.round(2) }
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

  def normalize(readings)
    linear_velocity = readings.shift / MAX_LINEAR_VELOCITY
    lateral_velocity = readings.shift / MAX_LATERAL_VELOCITY
    sensors = readings.map { |s| s / MAX_RADIUS }
    [linear_velocity, lateral_velocity, *sensors].map { |n| n.round(3) }
  end
end
