# Player car
class Car
  Z_ORDER = 5
  SPRITE_SCALE = 0.5

  LINEAR_ACCELERATION = 0.15
  BRAKING_POWER = 0.3
  LINEAR_FRICTION = 0.98
  # Top speed = 0.15 / (1 - 0.98) * 0.98 = 7.35px/fr = 441px/sec

  ANGULAR_ACCELERATION = 0.1
  ANGULAR_FRICTION = 0.9
  # Top angular velocity = 0.07 / (1 - 0.9) * 0.9 = 0.63deg/fr = 37.8deg/sec

  def initialize(initial_x, initial_y)
    @sprite = Gosu::Image.new('assets/Cars/car_red_1.png', retro: true)

    @velocity = 0
    @angular_velocity = 0
    @x = initial_x
    @y = initial_y
    @angle = 0
  end

  def update
    turn_left  if Gosu.button_down? Gosu::KbLeft
    turn_right if Gosu.button_down? Gosu::KbRight
    accelerate if Gosu.button_down? Gosu::KbUp
    brake      if Gosu.button_down? Gosu::KbDown

    turn
    move
  end

  def draw
    @sprite.draw_rot(@x, @y, Z_ORDER, @angle, 0.5, 0.6, SPRITE_SCALE, SPRITE_SCALE)
  end

  private

  def turn_right
    @angular_velocity += [ANGULAR_ACCELERATION / @velocity * 2, ANGULAR_ACCELERATION].min
  end

  def turn_left
    @angular_velocity -= [ANGULAR_ACCELERATION / @velocity * 2, ANGULAR_ACCELERATION].min
  end

  def accelerate
    @velocity += LINEAR_ACCELERATION
  end

  def brake
    @velocity -= BRAKING_POWER

    @velocity = [@velocity, 0].max
  end

  def move
    @x += Gosu.offset_x(@angle, @velocity)
    @y += Gosu.offset_y(@angle, @velocity)
    @x %= 1280 # TODO: magic number
    @y %= 768 # TODO: magic number

    @velocity *= LINEAR_FRICTION
  end

  def turn
    @angle += @angular_velocity * @velocity
    @angular_velocity *= ANGULAR_FRICTION
  end
end
