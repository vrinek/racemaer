# Debug dialog to input debug commands
class DebugDialog
  X = 0
  Y = 0
  Z_ORDER = 10
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
      @window.load_map!
    when /^reload car$/
      @window.load_car!
    end
  end
end
