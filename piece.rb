class Piece
  attr_accessor :position, :move_dirs, :color

  HORIZONTAL_VERTICAL = [[0, 1], [1, 0], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [1, -1], [-1, -1], [-1, 1]]

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
  end

  def move_into_check?(end_pos)
    return false unless self.moves.include?(end_pos)
    board_duplicate = @board.deep_dup
    board_duplicate.move(@position, end_pos)
    board_duplicate.in_check?(@color)
  end

  def valid_moves
    valid_moves = []

    possible_moves = self.moves
    possible_moves.each do |move|
      valid_moves << move unless move_into_check?(move)
    end

    valid_moves
  end

  def deep_dup(board = @board, position = @position, color = @color)
    self.class.new(board, position, color)
  end

end

class SlidingPiece < Piece

  def moves
    possible_moves = []
    directions = @move_dirs
    directions.each do |direction|
      possible_moves.concat(check_direction(@position, direction))
    end
    possible_moves
  end

  def check_direction(start_position, direction)
    possible_moves = []
    loop do
      start_position = start_position.zip(direction).map { |x,y| x + y }
      break unless @board.in_bounds?(start_position)
      other_piece = @board[start_position]
      if other_piece.nil?
        possible_moves << start_position
      else
        if other_piece.color != @color
          possible_moves << start_position
        end
        break
      end
    end
    possible_moves
  end

end

class Rook < SlidingPiece
  def initialize(*_args)
    super
    @move_dirs = HORIZONTAL_VERTICAL
  end
  def to_s
    " ♜ "
  end
end

class Bishop < SlidingPiece
  def initialize(*_args)
    super
    @move_dirs = DIAGONAL
  end
  def to_s
    " \u265D "
  end
end

class Queen < SlidingPiece
  def initialize(*_args)
    super
    @move_dirs = HORIZONTAL_VERTICAL + DIAGONAL
  end
  def to_s
    " ♛ "
  end
end

class SteppingPiece < Piece

  KNIGHT = [[2,1], [1,2], [-1,2], [-1,-2], [-2,1], [-2,-1], [2,-1],[1,-2]]

  def moves
    possible_moves = []
    self.update_move_dirs if self.class == Pawn
    directions = self.move_dirs
    directions.each do |direction|
      possible_moves.concat(check_direction(@position, direction))
    end
    possible_moves
  end

  def check_direction(start_position,direction)
    possible_moves = []
    start_position = start_position.zip(direction).map { |x,y| x + y }
    return possible_moves unless @board.in_bounds?(start_position)
    other_piece = @board[start_position]
    if other_piece.nil?
      possible_moves << start_position
    elsif other_piece.color != @color
      possible_moves << start_position
    end
    possible_moves
  end

end

class Knight < SteppingPiece
  def initialize(*_args)
    super
      @move_dirs = KNIGHT
  end
  def to_s
    " ♞ "
  end
end

class King < SteppingPiece
  def initialize(*_args)
    super
    @move_dirs = HORIZONTAL_VERTICAL + DIAGONAL
  end
  def to_s
    " ♚ "
  end
end

class Pawn < SteppingPiece
    def initialize(*_args)
    super
    update_move_dirs
  end
  def to_s
    " ♟ "
  end

  def update_move_dirs
      if @color == "white"
      @move_dirs = []
      forward_pieces = [@board[[position[0]+1, position[1]]], @board[[position[0]+2,position[1]]]]
      @move_dirs << [1,0] if forward_pieces[0].nil?
      @move_dirs << [2,0] if self.position[0] == 1 && forward_pieces[1].nil?
      diagonal_piece = @board[[position[0]+1, position[1]+1]]
      @move_dirs << [1,1] unless diagonal_piece.nil? || diagonal_piece.color == "white"
      diagonal_piece = @board[[position[0]+1, position[1]-1]]
      @move_dirs << [1,-1] unless diagonal_piece.nil? || diagonal_piece.color == "white"
    else
      @move_dirs = []
      forward_pieces = [@board[[position[0]-1, position[1]]], @board[[position[0]-2,position[1]]]]
      @move_dirs << [-1,0] if forward_pieces[0].nil?
      @move_dirs << [-2,0] if self.position[0] == 6 && forward_pieces[1].nil?
      diagonal_piece = @board[[position[0]-1, position[1]+1]]
      @move_dirs << [-1,1] unless diagonal_piece.nil? || diagonal_piece.color == "black"
      diagonal_piece = @board[[position[0]-1, position[1]-1]]
      @move_dirs << [-1,-1] unless diagonal_piece.nil? || diagonal_piece.color == "black"
    end
    @move_dirs
  end
end
