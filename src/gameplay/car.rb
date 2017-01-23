require 'gosu'

# Player car
class Car
  WIDTH = 32
  LENGTH = 64

  MASS = 10
  MOMENT_OF_INERTIA = 5000

  LINEAR_ACCELERATION = 5400
  REVERSE_ACCELERATION = LINEAR_ACCELERATION / 3

  ANGULAR_ACCELERATION = 0.1
  ANGULAR_FRICTION = 0.9

  attr_reader :rigid_body, :collision_shape
  attr_reader :angular_velocity
  attr_reader :actor_id

  def initialize(x:, y:, space:)
    @actor_id = :car_1

    initialize_rigid_body(x, y)
    initialize_collision_shape

    @angular_velocity = 0
    @actions_buffer = []

    space.add_body(rigid_body)
    space.add_shape(collision_shape)
  end

  def act(command:)
    @actions_buffer << command[:action]
  end

  def update
    rigid_body.reset_forces

    follow(@actions_buffer)
    @actions_buffer = []

    apply_physics
  end

  def presentation_view
    {
      x: rigid_body.pos.x,
      y: rigid_body.pos.y,
      angle: angle
    }
  end

  private

  def follow(actions)
    dt = 1 / 60.0 # TEMP: approximation

    turn_left(dt)  if actions.include?(:turn_left)
    turn_right(dt) if actions.include?(:turn_right)
    accelerate     if actions.include?(:accelerate)
    brake          if actions.include?(:brake)
  end

  def apply_physics
    dt = 1 / 60.0 # TEMP: approximation

    apply_tires_force(dt)
    turn(dt)
  end

  def initialize_rigid_body(x, y)
    @rigid_body = CP::Body.new(MASS, MOMENT_OF_INERTIA)
    rigid_body.p.x = x
    rigid_body.p.y = y
  end

  def initialize_collision_shape
    pad = 8
    verts = [
      CP::Vec2.new(+LENGTH / 2 - pad, +WIDTH / 2      ),
      CP::Vec2.new(+LENGTH / 2,       +WIDTH / 2 - pad),
      CP::Vec2.new(+LENGTH / 2,       -WIDTH / 2 + pad),
      CP::Vec2.new(+LENGTH / 2 - pad, -WIDTH / 2      ),
      CP::Vec2.new(-LENGTH / 2 + pad, -WIDTH / 2      ),
      CP::Vec2.new(-LENGTH / 2,       -WIDTH / 2 + pad),
      CP::Vec2.new(-LENGTH / 2,       +WIDTH / 2 - pad),
      CP::Vec2.new(-LENGTH / 2 + pad, +WIDTH / 2      ),
    ]
    @collision_shape = CP::Shape::Poly.new(rigid_body, verts, CP::Vec2::ZERO)
    collision_shape.collision_type = :car
  end

  def angle
    rigid_body.a.radians_to_gosu
  end

  def velocity
    rigid_body.v.length
  end

  def turn_right(dt)
    @angular_velocity += [ANGULAR_ACCELERATION / (velocity * dt) * 2, ANGULAR_ACCELERATION].min
  end

  def turn_left(dt)
    @angular_velocity -= [ANGULAR_ACCELERATION / (velocity * dt) * 2, ANGULAR_ACCELERATION].min
  end

  def accelerate
    @rigid_body.apply_force(direction_vector * LINEAR_ACCELERATION, CP::Vec2::ZERO)
  end

  def brake
    # TODO: Stop applying force when velocity is backwards
    @rigid_body.apply_force(direction_vector * REVERSE_ACCELERATION * -1, CP::Vec2::ZERO)
  end

  def apply_tires_force(dt)
    orthogonal_direction = CP::Vec2.for_angle(((angle + 90) % 360).gosu_to_radians)
    tires_force = (rigid_body.v / dt).project(orthogonal_direction) * -MASS
    rigid_body.apply_force(tires_force, CP::Vec2::ZERO)
  end

  def direction_vector
    CP::Vec2.for_angle(rigid_body.a)
  end

  def turn(dt)
    diff = (angular_velocity * (velocity * dt)).gosu_to_radians - 0.gosu_to_radians
    rigid_body.a += diff
    rigid_body.w *= ANGULAR_FRICTION

    @angular_velocity *= ANGULAR_FRICTION
  end
end
