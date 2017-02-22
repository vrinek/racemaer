require_relative '../tilesets.rb'

# Race track to drive on
class Track
  attr_reader :static_body
  attr_reader :collision_shapes
  attr_reader :lap
  attr_reader :map

  def initialize(map:, space:)
    @lap = 0
    @map = map
    initialize_static_body
    initialize_collision_shapes
    collision_shapes.each { |shape| space.add_shape(shape) }

    space.add_collision_func(:checkpoint, :car, &checkpoint_collision_func)
  end

  def update
    # noop
  end

  def pole_position
    map['pole_position'].map { |n| n * map['tilesize'] + map['tilesize'] / 2 }
  end

  private

  def initialize_static_body
    @static_body = CP::StaticBody.new
  end

  def initialize_collision_shapes
    @collision_shapes = []
    map['layers'].each do |layer|
      tileset = TILESETS[layer['tileset']]
      next unless tileset['collision_shapes']

      each_tile_of_layer(layer) do |tile_index, x, y|
        shapes = tileset['collision_shapes'][tile_index.to_s]
        next unless shapes

        offset = CP::Vec2.new(x * map['tilesize'], y * map['tilesize'])
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
