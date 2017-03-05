# Draws a single loose tire on the track
class PresentLooseTire
  Z_ORDER = 5

  def initialize(model:)
    @model = model
    @sprite = Gosu::Image.new('assets/Objects/tires_red.png')
  end

  def draw
    @sprite.draw_rot(
      view[:x], view[:y], Z_ORDER,
      view[:angle], 0.5, 0.5,
      scale, scale
    )
  end

  private

  def view
    @model.presentation_view
  end

  def scale
    @model.class::RADIUS * 2 / @sprite.width.to_f
  end
end
