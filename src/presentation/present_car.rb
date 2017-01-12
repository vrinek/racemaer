# Top-down presentation of the car
class PresentCar
  Z_ORDER = 5

  def initialize(model:)
    @sprite = Gosu::Image.new('assets/Cars/car_blue_1.png', retro: true)
    @model = model
  end

  def draw
    @sprite.draw_rot(
      view[:x], view[:y], Z_ORDER,
      view[:angle], 0.5, 0.5,
      scale_x, scale_y
    )
  end

  private

  def view
    @model.presentation_view
  end

  def scale_x
    @model.class::WIDTH / @sprite.width.to_f
  end

  def scale_y
    @model.class::LENGTH / @sprite.height.to_f
  end
end
