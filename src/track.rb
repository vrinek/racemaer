require_relative './debug_collision_shape.rb'
require_relative './debug_track_tile.rb'

# Race track to drive on
class Track
  Z_ORDERS = 0...5

  TILE_SIZE = 128

  TILESETS = {
    'Asphalt road' => {
      files: 'assets/Asphalt road/road_asphalt%02d.png',
      tiles: 90,
      collision_shapes: {
        2 => [
          [[0,0], [128,0], [128,20], [0,20]],
          [[0,108], [128,108], [128,128], [0,128]]
        ],
        3 => [
          [[0,128], [3,95], [22,100], [20,128]],
          [[3,95], [13,62], [32,72], [22,100]],
          [[13,62], [33,33], [48,48], [32,72]],
          [[33,33], [62,13], [72,32], [48,48]],
          [[62,13], [95,3], [100,22], [72,32]],
          [[95,3], [128,0], [128,20], [100,22]],
          [[108,128], [113,113], [128,108], [128,128]]
        ],
        4 => [[[0,0], [128,0], [128,20], [0,20]]],
        5 => [
          [[0,0], [32,3], [28,22], [0,20]],
          [[32,3], [66,13], [56,32], [28,22]],
          [[66,13], [95,33], [80,48], [56,32]],
          [[95,33], [115,62], [96,72], [80,48]],
          [[115,62], [125,95], [106,100], [96,72]],
          [[125,95], [128,128], [108,128], [106,100]],
          [[0,108], [15,113], [20,128], [0,128]]
        ],
        8 => [
          [[26,128], [68,68], [82,82], [49,128]],
          [[68,68], [128,26], [128,49], [82,82]]
        ],
        9 => [
          [[0,26], [60,6], [66,27], [0,49]],
          [[60,6], [128,0], [128,20], [66,27]]
        ],
        10 => [
          [[0,0], [68,6], [60,27], [0,20]],
          [[68,6], [128,26], [128,49], [60,27]]
        ],
        11 => [
          [[0,26], [60,68], [46,82], [0,49]],
          [[60,68], [102,128], [79,128], [46,82]]
        ],
        21 => [[[20,0], [20,128], [0,128], [0,0]]],
        23 => [[[128,0], [128,128], [108,128], [108,0]]],
        26 => [
          [[0,128], [6,60], [27,66], [20,128]],
          [[6,60], [26,0], [49,0], [27,66]]
        ],
        27 => [[[108,128], [113,113], [128,108], [128,128]]],
        29 => [
          [[128,128], [108,128], [101,66], [122,60]],
          [[122,60], [101,66], [79,0], [102,0]]
        ],
        39 => [
          [[0,0], [20,0], [22,28], [3,32]],
          [[3,32], [22,28], [32,56], [13,66]],
          [[13,66], [32,56], [48,80], [33,95]],
          [[33,95], [48,80], [72,96], [62,115]],
          [[62,115], [72,96], [100,106], [95,125]],
          [[95,125], [100,106], [128,108], [128,128]],
          [[108,0], [128,0], [128,20], [113,15]]
        ],
        40 => [[[0,108], [128,108], [128,128], [0,128]]],
        41 => [
          [[128,0], [125,32], [106,28], [108,0]],
          [[125,32], [115,66], [96,56], [106,28]],
          [[115,66], [95,95], [80,80], [96,56]],
          [[95,95], [66,115], [56,96], [80,80]],
          [[66,115], [33,125], [28,106], [56,96]],
          [[33,125], [0,128], [0,108], [28,106]],
          [[20,0], [15,15], [0,20], [0,0]]
        ],
        44 => [
          [[0,0], [20,0], [27,60], [6,68]],
          [[6,68], [27,60], [49,128], [26,128]]
        ],
        45 => [[[108,0], [128,0], [128,20], [113,15]]],
        47 => [
          [[128,0], [122,68], [101,62], [108,0]],
          [[122,68], [102,128], [79,128], [101,62]]
        ],
        62 => [
          [[26,0], [49,0], [82,46], [68,60]],
          [[68,60], [82,46], [128,79], [128,102]]
        ],
        63 => [
          [[128,128], [60,122], [66,101], [128,108]],
          [[60,122], [0,102], [0,79], [66,101]]
        ],
        64 => [
          [[0,128], [0,108], [62,101], [68,122]],
          [[68,122], [62,101], [128,79], [128,102]]
        ],
        65 => [
          [[102,0], [60,60], [46,46], [79,0]],
          [[60,60], [0,102], [0,79], [46,46]]
        ],
      }
    },
    'Grass' => {
      files: 'assets/Grass/land_grass%02d.png',
      tiles: 14
    }
  }

  attr_reader :static_body
  attr_reader :collision_shapes, :checkpoint_shapes
  attr_reader :lap

  def initialize(map:, space:)
    @lap = 0
    @map = map
    initialize_tiles
    initialize_static_body
    initialize_collision_shapes
    collision_shapes.each { |shape| space.add_shape(shape) }
    initialize_checkpoints
    checkpoint_shapes.each { |shape| space.add_shape(shape) }
    space.add_collision_func(:checkpoint, :car, &flag_collision_func)
  end

  def update
    # nothing to do
  end

  def draw(debug: false)
    @map['layers'].reverse_each do |layer|
      z = Z_ORDERS.to_a[layer['z_order']]
      each_tile_of_layer(layer) do |tile_index, x, y|
        sprite = @tiles[layer['tileset']][tile_index]
        sprite.draw(x * TILE_SIZE, y * TILE_SIZE, z)
      end
    end

    return unless debug
    collision_shapes.each { |shape| DebugCollisionShape.new(shape).draw }
    checkpoint_shapes.each { |shape| DebugCollisionShape.new(shape).draw }
    each_tile_of_layer(@map['layers'][0]) do |tile_index, x, y|
      DebugTrackTile.new(x, y, tile_index).draw
    end
  end

  def pole_position
    @map['pole_position'].map { |n| n * TILE_SIZE + TILE_SIZE / 2 }
  end

  private

  def initialize_static_body
    @static_body = CP::StaticBody.new
  end

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

  def initialize_collision_shapes
    @collision_shapes = []
    @map['layers'].each do |layer|
      tileset = TILESETS[layer['tileset']]
      next unless tileset[:collision_shapes]

      each_tile_of_layer(layer) do |tile_index, x, y|
        shapes = tileset[:collision_shapes][tile_index]
        next unless shapes

        offset = CP::Vec2.new(x * TILE_SIZE, y * TILE_SIZE)
        shapes.each do |vertice_data|
          verts = vertice_data.map { |(vx, vy)| CP::Vec2.new(vx, vy) }.reverse
          @collision_shapes << CP::Shape::Poly.new(static_body, verts, offset)
        end
      end
    end
  end

  def initialize_checkpoints
    @checkpoint_shapes = []
    @map['checkpoints'].each_with_index do |(start, finish), index|
      is_flag = index == @map['flag_index']
      initialize_checkpoint(from: start, to: finish, is_flag: is_flag)
    end
  end

  def initialize_checkpoint(from:, to:, is_flag:)
    vec1 = CP::Vec2.new(*from.map { |n| n * TILE_SIZE })
    vec2 = CP::Vec2.new(*to.map { |n| n * TILE_SIZE })

    checkpoint_shape = CP::Shape::Segment.new(static_body, vec1, vec2, 10)
    checkpoint_shape.sensor = true
    checkpoint_shape.collision_type = :checkpoint
    checkpoint_shape.object = { is_flag: is_flag }
    @checkpoint_shapes << checkpoint_shape
  end

  def flag_collision_func
    last_flag_time = nil

    # Chipmunk expects this to return true to continue processing the collision
    -> (arbiter) do
      return true unless arbiter.first_contact?

      checkpoint = arbiter.shapes.first
      if checkpoint.object[:is_flag]
        count_lap
        print_lap_time(last_flag_time)
        last_flag_time = Time.now
      else
        print_lap_time(last_flag_time)
      end

      true
    end
  end

  def count_lap
    @lap += 1
    puts "Lap #{lap}"
  end

  def print_lap_time(last_lap_time)
    return unless last_lap_time
    puts Time.now - last_lap_time
  end

  def each_tile_of_layer(layer)
    layer['map'].each_with_index do |row, y|
      row.each_with_index do |tile_index, x|
        yield(tile_index, x, y) if tile_index
      end
    end
  end
end
