require_relative '../tilesets.rb'

# 2D representation of the track
class PresentTrack
  Z_ORDERS = 0...5

  def initialize(model:)
    @model = model
    @tiles = {}

    @model.map['layers'].each do |layer|
      load_tileset(layer['tileset'])
    end
  end

  def draw
    @model.map['layers'].reverse_each do |layer|
      z = Z_ORDERS.to_a[layer['z_order']]
      each_tile_of_layer(layer) do |tile_index, x, y|
        sprite = @tiles[layer['tileset']][tile_index]
        sprite.draw(x * @model.map['tilesize'], y * @model.map['tilesize'], z)
      end
    end
  end

  private

  def load_tileset(tileset_name)
    return if @tiles[tileset_name]

    tileset = TILESETS[tileset_name]

    @tiles[tileset_name] = Array.new(tileset[:tiles] + 1)
    tileset[:tiles].times do |i|
      filename = format(tileset[:files], i + 1)
      @tiles[tileset_name][i + 1] = Gosu::Image.new(filename, retro: true)
    end
  end

  def each_tile_of_layer(layer)
    layer['map'].each_with_index do |row, y|
      row.each_with_index do |tile_index, x|
        yield(tile_index, x, y) if tile_index
      end
    end
  end
end
