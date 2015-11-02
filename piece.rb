class Piece
attr_accessor :position

  def initialize(board, position)
    @board = board
    @position = position
  end

  def to_s
    " #{self.class.to_s[0]} "
  end



end

class SlidingPiece < Piece

  def moves
    possible_moves = []
    directions = self.move_dirs #[:horizontal, :vertical, :diagonal]
    directions.each do |direction|
      case direction
      when :horizontal
        row = piece.position[1]
        
        #check left and right
      when :vertical
        #check above and below
      when :diagonal
        #check four diagonal directions
      end
    end
  end

end

class Rook < SlidingPiece
end

class Bishop < SlidingPiece
end

class Queen < SlidingPiece
end

class SteppingPiece < Piece
end

class Knight < SteppingPiece
end

class King < SteppingPiece
end

class Pawn
  #panic
end
