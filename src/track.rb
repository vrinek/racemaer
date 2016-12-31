# Race track to drive on
class Track
  Z_ORDERS = 0...5

  TILE_SIZE = 128

  TILESETS = {
    'Asphalt road' => {
      files: 'assets/Asphalt road/road_asphalt%02d.png',
      tiles: 90
    },
    'Grass' => {
      files: 'assets/Grass/land_grass%02d.png',
      tiles: 14
    }
  }

  def initialize(map:)
    @map = map
    initialize_tiles
  end

  def update
    # noop
  end

  def draw
    @map['layers'].reverse_each do |layer|
      z = Z_ORDERS.to_a[layer['z_order']]
      layer['map'].each_with_index do |row, y|
        row.each_with_index do |tile_index, x|
          draw_tile(@tiles[layer['tileset']][tile_index], x, y, z) if tile_index
        end
      end
    end
  end

  private

  def initialize_tiles
    @tiles = {}

    @map['layers'].each do |layer|
      load_tileset(layer['tileset'])
    end
  end

  def load_tileset(tileset_name)
    return if @tiles[tileset_name]

    tileset = TILESETS[tileset_name]

    @tiles[tileset_name] = Array.new(tileset[:tiles] + 1)
    tileset[:tiles].times do |i|
      filename = format(tileset[:files], i + 1)
      @tiles[tileset_name][i + 1] = Gosu::Image.new(filename, retro: true)
    end
  end

  def draw_tile(tile, x, y, z)
    tile.draw(x * TILE_SIZE, y * TILE_SIZE, z)
  end
end
