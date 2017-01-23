# Debug dialog to input debug commands
class DebugDialog
  X = 0
  Y = 0
  Z_ORDER = 11
  FONT_SIZE = 16 # 16px line height

  def initialize(window:)
    @window = window
  end

  def update
    if !@window.text_input && Gosu.button_down?(Gosu::KbBacktick)
      @window.text_input = Gosu::TextInput.new
    elsif @window.text_input && Gosu.button_down?(Gosu::KbReturn)
      parse(@window.text_input.text)
      @window.text_input = nil
    end
  end

  def draw
    return unless @window.text_input

    Gosu::Image.from_text(@window.text_input.text, FONT_SIZE)
      .draw(X, Y, Z_ORDER)
  end

  private

  def parse(text)
    case text
    when /^reload map$/
      # @window.load_map!
      puts 'Currently broken, sorry'
    when /^reload car$/
      # @window.load_car!
      puts 'Currently broken, sorry'
    when /^reload tire$/
      # @window.load_loose_tire!
      puts 'Currently broken, sorry'
    when /^debug on$/
      @window.enable_debug!
    end
  end
end
