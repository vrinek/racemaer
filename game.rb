require 'gosu'

class GameWindow < Gosu::Window
  CAR_SCALE = 0.3
  TURNING_SPEED = 0.07
  ACCELERATION = 0.15
  BREAKING_POWER = 0.3
  ANGULAR_FRICTION = 0.9
  LINEAR_FRICTION = 0.98

  def initialize
    super 640, 480
    self.caption = 'Gosu Tutorial Game'

    @car = Gosu::Image.new('car.png')
    @velocity = 0
    @angle_velocity = 0
    @x = 320
    @y = 240
    @angle = 0
  end

  def update
    if Gosu.button_down? Gosu::KbLeft
      @angle_velocity -= TURNING_SPEED
    end

    if Gosu.button_down? Gosu::KbRight
      @angle_velocity += TURNING_SPEED
    end

    if Gosu.button_down? Gosu::KbUp
      accelerate
    end

    if Gosu.button_down? Gosu::KbDown
      brake
    end

    turn
    move
  end

  def draw
    @car.draw_rot(@x, @y, 1, @angle, 0.5, 0.6, CAR_SCALE, CAR_SCALE)
  end

  private

  def accelerate
    @velocity += ACCELERATION
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

window = GameWindow.new
window.show
