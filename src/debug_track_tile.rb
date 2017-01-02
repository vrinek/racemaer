# Debug view of a single track tile
class DebugTrackTile
  Z_ORDER = 11
  FONT_SIZE = 12
  TILE_SIZE = 128

  attr_reader :x, :y, :num

  def initialize(x, y, num)
    @x, @y, @num = x, y, num
  end

  def draw
    Gosu::Image.from_text(num.to_s, FONT_SIZE)
      .draw(x * TILE_SIZE, y * TILE_SIZE, Z_ORDER)
    Gosu::Image.from_text("#{x}, #{y}", FONT_SIZE)
      .draw(x * TILE_SIZE, y * TILE_SIZE + FONT_SIZE, Z_ORDER)
  end
end
