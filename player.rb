require_relative "display"

class Player
  attr_accessor :display, :color

  def initialize(game, color)
    @color = color
    @display ||= Display.new(game)
  end

  def move(selected_piece = nil)
    result = nil
    until result
      @display.render(@color, selected_piece)
      result = @display.get_input
    end
    result
  end

  # def move_second(selected_piece)
  #   result = nil
  #   until result
  #     @display.render(@color)
  #     result = @display.get_input
  #   end
  #   result
  # end

end
