class Car
  SPRITE_SCALE = 0.3

  LINEAR_ACCELERATION = 0.15
  BREAKING_POWER = 0.3
  LINEAR_FRICTION = 0.98
  # Top speed = 0.15 / (1 - 0.98) * 0.98 = 7.35px/fr

  ANGULAR_ACCELERATION = 0.07
  ANGULAR_FRICTION = 0.9
  # Top angular velocity = 0.07 / (1 - 0.9) * 0.9 = 0.63deg/fr

  def initialize(x, y)
    @sprite = Gosu::Image.new('car.png')
    @velocity = 0
    @angle_velocity = 0
    @x = x
    @y = y
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
    @sprite.draw_rot(@x, @y, 1, @angle, 0.5, 0.6, SPRITE_SCALE, SPRITE_SCALE)
  end

  private

  def turn_right
    @angle_velocity += ANGULAR_ACCELERATION
  end

  def turn_left
    @angle_velocity -= ANGULAR_ACCELERATION
  end

  def accelerate
    @velocity += LINEAR_ACCELERATION
  end

  def brake
    @velocity -= BREAKING_POWER

    @velocity = [@velocity, 0].max
  end

  def move
    @x += Gosu.offset_x(@angle, @velocity)
    @y += Gosu.offset_y(@angle, @velocity)
    @x %= 640
    @y %= 480

    @velocity *= LINEAR_FRICTION
  end

  def turn
    @angle += @angle_velocity * @velocity
    @angle_velocity *= ANGULAR_FRICTION
  end
end
