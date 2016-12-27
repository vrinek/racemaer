class Track
  Z_ORDER = 0
  TILE_SIZE = 128
  TILE_SET_SIZE = 90

  def initialize(map:)
    initialize_tiles
    @map = map
  end

  def update
    # noop
  end

  def draw
    @map.each_with_index do |row, y|
      row.each_with_index do |tile_index, x|
        draw_tile(@tiles[tile_index], x, y) if tile_index
      end
    end
  end

  private

  def initialize_tiles
    @tiles = Array.new(TILE_SET_SIZE + 1)
    TILE_SET_SIZE.times do |i|
      filename = format('assets/Asphalt road/road_asphalt%02d.png', i + 1)
      @tiles[i + 1] = Gosu::Image.new(filename, retro: true)
    end
  end

  def draw_tile(tile, x, y)
    tile.draw(x * TILE_SIZE, y * TILE_SIZE, Z_ORDER)
  end
end
