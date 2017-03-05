require 'json'

require_relative './interfaced_array.rb'
require_relative './interface/commander.rb'

require_relative './ai_input/ai_drive_car.rb'

# Handles human input at the top level and delegates to Commanders for affecting the game state.
class AiInput
  COMMANDERS = {
    'Car' => AIDriveCar
  }.freeze

  def initialize(actors:, sensors:)
    @commanders = InterfacedArray.new(interface: Commander)
    params = JSON.parse(File.open('parameters.json').read)

    actors.each do |actor_id, actor|
      commander_class = COMMANDERS[actor.class.to_s]
      fail "Unknown actor class #{actor.class}" unless commander_class
      @commanders << commander_class.new(actor_id: actor_id, sensors: sensors, params: params)
    end
  end

  def destroy; end

  def commands
    @commanders.map(&:commands).flatten
  end
end
