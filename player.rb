require_relative "display"

class Player
  attr_accessor :display, :color

  def initialize(board, color)
    @color = color
    @display ||= Display.new(board)
  end

  def move
    result = nil
    until result
      @display.render(@color)
      result = @display.get_input
    end
    result
  end

end
