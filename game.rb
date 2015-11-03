require_relative "board"
require_relative "display"
require_relative "player"
require_relative "piece"

class Game
  attr_accessor :display, :board, :color, :current_player

  def initialize
    @board = Board.new
    @player1 = Player.new(@board, "white")
    @player2 = Player.new(@board, "black")
    @turn = 1
    @current_player = @player1
    play
  end

  def play
    until @board.check_mate?(@current_player.color)
      start_pos = select_start
      end_pos = select_end(@board[start_pos])
      @board.move(start_pos, end_pos)
      new_turn
    end
  end

  def new_turn
    @turn += 1
    @turn.even? ? @current_player = @player2 : @current_player = @player1
  end

  def select_start
    begin
      start_pos = @current_player.move
      fail ArgumentError.new if @board[start_pos].nil?
      fail RuntimeError.new if @board[start_pos].color != @current_player.color
    rescue ArgumentError
      puts "There's no piece here"
      sleep 1
      retry
    rescue RuntimeError
      puts "Wrong color piece"
      sleep 1
      retry
    end
    start_pos
  end

  def select_end(start_piece)
    begin
      end_pos = @current_player.move
      fail ArgumentError.new unless start_piece.moves.include?(end_pos)
    rescue ArgumentError
      puts "That piece can't move there"
      sleep 1
      retry
    end
    end_pos
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new
end
