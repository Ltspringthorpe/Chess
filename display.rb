require "colorize"
require_relative "cursorable"
require_relative "board"
require 'byebug'

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def build_grid
    @board.board.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(@board, i, j)
      if piece.nil?
        "   ".colorize(color_options)
      else
        piece.to_s.colorize(color_options)
      end
    end
  end

  def colors_for(board,i, j)
    if @selected_piece.nil?
      if !board[[i,j]].nil?
        piece = board[[i,j]]
        text_color = piece.color
        text_color == "black" ? text_color = :black : text_color = :light_white
      end
      cursor_piece = board[@cursor_pos]
      if [i, j] == @cursor_pos
        bg = :light_red
      elsif (i + j).odd?
        if !cursor_piece.nil? && cursor_piece.moves.include?([i, j])
          bg = :light_yellow
        else
         bg = :white
        end
      else
        if !cursor_piece.nil? && cursor_piece.moves.include?([i, j])
          bg = :yellow
        else
         bg = :light_black
        end
      end
    else
      if !board[[i,j]].nil?
        piece = board[[i,j]]
        text_color = piece.color
        text_color == "black" ? text_color = :black : text_color = :light_white
      end
      cursor_piece = board[@cursor_pos]
      if [i, j] == @cursor_pos
        bg = :light_red
      elsif (i + j).odd?
        if @selected_piece.moves.include?([i, j])
          bg = :light_yellow
        else
         bg = :white
        end
      else
        if @selected_piece.moves.include?([i, j])
          bg = :yellow
        else
         bg = :light_black
        end
      end
    end
    { background: bg, color: text_color }
  end

  def render(color, selected_piece)
    @selected_piece = selected_piece
    color = color.capitalize
    #system("clear")
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
    puts "\n#{color}'s turn: "
    build_grid.each { |row| puts row.join }
  end
end

if $PROGRAM_NAME == __FILE__
  #debugger
  board = Board.new
  display = Display.new(board)
  result = nil
  p board[[1,0]].moves
  #p board[[6,1]].methods
  #p board[[6,1]].move_into_check?([5,0])
  p board.check_mate?("black")
  until result
    display.render
    result = display.get_input
  end

end
