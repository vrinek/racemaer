# Debug view of a single track tile
class DebugTrackTile
  Z_ORDER = 11
  FONT_SIZE = 12
  TILE_SIZE = 128

  attr_reader :x, :y

  def initialize(x, y, num)
    @x, @y = x, y

    @num_image = Gosu::Image.from_text(num.to_s, FONT_SIZE)
    @coordinates_image = Gosu::Image.from_text("#{x}, #{y}", FONT_SIZE)
  end

  def draw
    @num_image.draw(x * TILE_SIZE, y * TILE_SIZE, Z_ORDER)
    @coordinates_image.draw(x * TILE_SIZE, y * TILE_SIZE + FONT_SIZE, Z_ORDER)
  end
end
