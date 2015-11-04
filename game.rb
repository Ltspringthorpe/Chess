require_relative "board"
require_relative "display"
require_relative "player"
require_relative "piece"

class Game
  attr_accessor :display, :board, :color, :current_player

  def initialize
    @board = Board.new
    @player1 = Player.new(self, "white")
    @player2 = Player.new(self, "black")
    @turn = 1
    @current_player = @player1
    play
  end

  def play
    until @board.check_mate?(@current_player.color)
      begin
        puts @board.class
        puts @board.in_check?("black")
        if @board.in_check?(@current_player.color)
          #system("clear")
          puts "You're in check!"
          sleep 1
        end
        start_pos = select_start
        @selected_piece = @board[start_pos]
        end_pos = select_end(@selected_piece)
        next if end_pos == "reset_piece"
        fail "Piece can't move like that" unless @selected_piece.valid_moves.include?(end_pos)
      rescue
        puts "Piece can't move like that. Try again."
        sleep 1
        retry
      end
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
      end_pos = @current_player.move(@selected_piece)
      return end_pos if end_pos == "reset_piece"
      #fail ArgumentError.new unless start_piece.moves.include?(end_pos)
    rescue ArgumentError
      #puts "That piece can't move there"
      #sleep 1
    end
    end_pos
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new
end
