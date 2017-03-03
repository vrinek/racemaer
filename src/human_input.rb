require_relative './interfaced_array.rb'
require_relative './interface/commander.rb'

require_relative './human_input/drive_car.rb'

# Handles human input at the top level and delegates to Commanders for affecting the game state.
class HumanInput
  COMMANDERS = {
    'Car' => DriveCar
  }.freeze

  def initialize(actors:)
    @commanders = InterfacedArray.new(interface: Commander)

    actors.each do |actor_id, actor|
      commander_class = COMMANDERS[actor.class.to_s]
      fail "Unknown actor class #{actor.class}" unless commander_class
      @commanders << commander_class.new(actor_id: actor_id)
    end
  end

  def destroy; end

  def commands
    @commanders.map(&:commands).flatten
  end
end
