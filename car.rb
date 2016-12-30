# Player car
class Car
  Z_ORDER = 5
  SPRITE_SCALE = 0.5

  LINEAR_ACCELERATION = 540 # 9 * 60 # 0.15 * 60
  BRAKING_POWER = 1080 # 0.3 * 60 * 60
  LINEAR_FRICTION = 0.3 # ~0.98**60
  # Top speed = 0.15 / (1 - 0.98) * 0.98 = 7.35px/fr = 441px/sec

  ANGULAR_ACCELERATION = 0.1
  ANGULAR_FRICTION = 0.9
  # Top angular velocity = 0.07 / (1 - 0.9) * 0.9 = 0.63deg/fr = 37.8deg/sec

  attr_reader :sprite
  attr_reader :rigid_body
  attr_reader :angular_velocity
  attr_reader :x, :y, :angle

  def initialize(x:, y:, space:)
    @sprite = Gosu::Image.new('assets/Cars/car_blue_1.png', retro: true)

    @rigid_body = CP::Body.new(1, 1)
    space.add_body(rigid_body)

    @angular_velocity = 0
    rigid_body.p.x = x
    rigid_body.p.y = y
    @angle = 0
  end

  def update
    rigid_body.reset_forces
    dt = 1 / 60.0 # TEMP: approximation

    turn_left(dt)  if Gosu.button_down? Gosu::KbLeft
    turn_right(dt) if Gosu.button_down? Gosu::KbRight
    accelerate     if Gosu.button_down? Gosu::KbUp
    brake          if Gosu.button_down? Gosu::KbDown

    apply_tires_force(dt)

    turn(dt)
  end

  def draw
    sprite.draw_rot(rigid_body.p.x, rigid_body.p.y, Z_ORDER, angle, 0.5, 0.6, SPRITE_SCALE, SPRITE_SCALE)
  end

  private

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
    @rigid_body.apply_force(direction_vector * BRAKING_POWER * -1, CP::Vec2::ZERO)
  end

  def apply_tires_force(dt)
    orthogonal_direction = CP::Vec2.for_angle(((angle + 90) % 360).gosu_to_radians)
    tires_force = (rigid_body.v / dt).project(orthogonal_direction) * -1
    rigid_body.apply_force(tires_force, CP::Vec2::ZERO)
  end

  def direction_vector
    CP::Vec2.for_angle(angle.gosu_to_radians)
  end

  def turn(dt)
    @angle += angular_velocity * (velocity * dt)
    @angular_velocity *= ANGULAR_FRICTION
  end
end
