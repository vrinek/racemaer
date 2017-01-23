# 2D debug representation of a track
class DebugTrack
  def initialize(model:)
    @debug_collision_shapes = model.collision_shapes.map { |shape| DebugCollisionShape.new(shape) }

    @debug_track_tiles = []
    each_tile_of_layer(model.map['layers'][0]) do |tile_index, x, y|
      @debug_track_tiles << DebugTrackTile.new(x, y, tile_index)
    end
  end

  def draw
    @debug_collision_shapes.each(&:draw)
    @debug_track_tiles.each(&:draw)
  end

  private

  def each_tile_of_layer(layer)
    layer['map'].each_with_index do |row, y|
      row.each_with_index do |tile_index, x|
        yield(tile_index, x, y) if tile_index
      end
    end
  end
end
