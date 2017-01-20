require_relative './debug_collision_shape.rb'
require_relative './debug_track_tile.rb'
require_relative './checkpoint.rb'
require_relative './tilesets.rb'

# Race track to drive on
class Track
  Z_ORDERS = 0...5

  TILE_SIZE = 128

  attr_reader :static_body
  attr_reader :collision_shapes
  attr_reader :lap, :checkpoints

  def initialize(map:, space:)
    @lap = 0
    @map = map
    initialize_tiles
    initialize_static_body
    initialize_collision_shapes
    collision_shapes.each { |shape| space.add_shape(shape) }

    @checkpoints = Checkpoint.new_with(map: @map, static_body: static_body, space: space)

    space.add_collision_func(:checkpoint, :car, &checkpoint_collision_func)
  end

  def update(commands:)
    checkpoints.each(&:update)
  end

  def draw(debug: false)
    @map['layers'].reverse_each do |layer|
      z = Z_ORDERS.to_a[layer['z_order']]
      each_tile_of_layer(layer) do |tile_index, x, y|
        sprite = @tiles[layer['tileset']][tile_index]
        sprite.draw(x * TILE_SIZE, y * TILE_SIZE, z)
      end
    end
    checkpoints.each { |checkpoint| checkpoint.draw(debug: debug) }

    return unless debug
    collision_shapes.each { |shape| DebugCollisionShape.new(shape).draw }
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

  def checkpoint_collision_func
    last_flag_time = nil

    # Chipmunk expects this to return true to continue processing the collision
    lambda do |arbiter|
      return true unless arbiter.first_contact?

      checkpoint = arbiter.shapes.first.object
      if checkpoint[:is_flag]
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
