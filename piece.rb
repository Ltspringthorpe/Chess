class Piece
  attr_accessor :position, :move_dirs, :color

  HORIZONTAL_VERTICAL = [[0, 1], [1, 0], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [1, -1], [-1, -1], [-1, 1]]

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
  end

  def to_s
    self.class == Knight ? " N " : " #{self.class.to_s[0]} "
  end

  def move_into_check?(end_pos)
    return false unless self.moves.include?(end_pos)
    board_duplicate = @board.deep_dup
    board_duplicate.move(@position, end_pos)
    board_duplicate.in_check?(@color)
  end

  def valid_moves?
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

  def initialize(board, position, color)
    super
  end

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

  def initialize(board, position, color)
    super
    @move_dirs = HORIZONTAL_VERTICAL
  end
end

class Bishop < SlidingPiece
  def initialize(board, position, color)
    super
    @move_dirs = DIAGONAL
  end
end

class Queen < SlidingPiece
  def initialize(board, position, color)
    super
    @move_dirs = HORIZONTAL_VERTICAL + DIAGONAL
  end
end

class SteppingPiece < Piece

  KNIGHT = [[2,1], [1,2], [-1,2], [-1,-2], [-2,1], [-2,-1], [2,-1],[1,-2]]

  def initialize(board, position, color)
    super
  end

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
  def initialize(board, position, color)
    super
      @move_dirs = KNIGHT
  end
end

class King < SteppingPiece
  def initialize(board, position, color)
    super
    @move_dirs = HORIZONTAL_VERTICAL + DIAGONAL
  end
end

class Pawn < SteppingPiece
  def initialize(board, position, color)
    super
    update_move_dirs
  end

  def update_move_dirs
      if @color == "white"
      @move_dirs = [[1,0]]
      @move_dirs << [2,0] if self.position[0] == 1
      diagonal_piece = @board[[position[0]+1, position[1]+1]]
      @move_dirs << [1,1] unless diagonal_piece.nil? || diagonal_piece.color == "white"
      diagonal_piece = @board[[position[0]+1, position[1]-1]]
      @move_dirs << [1,-1] unless diagonal_piece.nil? || diagonal_piece.color == "white"
    else
      @move_dirs = [[-1,0]]
      @move_dirs << [-2,0] if self.position[0] == 6
      diagonal_piece = @board[[position[0]-1, position[1]+1]]
      @move_dirs << [-1,1] unless diagonal_piece.nil? || diagonal_piece.color == "black"
      diagonal_piece = @board[[position[0]-1, position[1]-1]]
      @move_dirs << [-1,-1] unless diagonal_piece.nil? || diagonal_piece.color == "black"
    end
    @move_dirs
  end
end
