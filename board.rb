require_relative "piece"

class Board
  attr_accessor :board, :white_pieces, :black_pieces, :white_king, :black_king
  def initialize(populate = true)
    @board = Array.new(8) {Array.new(8)}
    @white_pieces = []
    @black_pieces = []
    @white_king = nil
    @black_king = nil
    populate_board if populate
  end

  def populate_board
    color = "white"
    @board[0][0] = Rook.new(self, [0,0], color)
    @board[0][1] = Knight.new(self, [0,1], color)
    @board[0][2] = Bishop.new(self, [0,2], color)
    @board[0][3] = Queen.new(self, [0,3], color)
    @board[0][4] = King.new(self, [0,4], color)
    @board[0][5] = Bishop.new(self, [0,5], color)
    @board[0][6] = Knight.new(self, [0,6], color)
    @board[0][7] = Rook.new(self, [0,7], color)
    @board[1][0] = Pawn.new(self, [1,0], color)
    @board[1][1] = Pawn.new(self, [1,1], color)
    @board[1][2] = Pawn.new(self, [1,2], color)
    @board[1][3] = Pawn.new(self, [1,3], color)
    @board[1][4] = Pawn.new(self, [1,4], color)
    @board[1][5] = Pawn.new(self, [1,5], color)
    @board[1][6] = Pawn.new(self, [1,6], color)
    @board[1][7] = Pawn.new(self, [1,7], color)

    @board[0..1].each do |row|
      row.each do |piece|
        @white_pieces << piece
      end
    end

    color = "black"
    @board[7][0] = Rook.new(self, [7,0], color)
    @board[7][1] = Knight.new(self, [7,1], color)
    @board[7][2] = Bishop.new(self, [7,2], color)
    @board[7][3] = Queen.new(self, [7,3], color)
    @board[7][4] = King.new(self, [7,4], color)
    @board[7][5] = Bishop.new(self, [7,5], color)
    @board[7][6] = Knight.new(self, [7,6], color)
    @board[7][7] = Rook.new(self, [7,7], color)
    @board[6][0] = Pawn.new(self, [6,0], color)
    @board[6][1] = Pawn.new(self, [6,1], color)
    @board[6][2] = Pawn.new(self, [6,2], color)
    @board[6][3] = Pawn.new(self, [6,3], color)
    @board[6][4] = Pawn.new(self, [6,4], color)
    @board[6][5] = Pawn.new(self, [6,5], color)
    @board[6][6] = Pawn.new(self, [6,6], color)
    @board[6][7] = Pawn.new(self, [6,7], color)

    @board[6..7].each do |row|
      row.each do |piece|
        @black_pieces << piece
      end
    end

    @white_king = @board[0][4]
    @black_king = @board[6][0]
  end

  def [](pos)
    @board[pos[0]][pos[1]]
  end

  def []=(pos, value)
    @board[pos[0]][pos[1]] = value
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def move(start_pos, end_pos)
    fail "outside of board" unless in_bounds?(end_pos)
    fail "no piece at start" if self[start_pos].nil?
    piece = self[start_pos]
    fail "piece can't move like that" unless piece.moves.include?(end_pos)

    piece.position = end_pos
    self[start_pos] = nil
    self[end_pos] = piece
  end

  def in_check?(color)
    case color
    when "white"
      opponent_pieces = @black_pieces
      king = @white_king
    when "black"
      opponent_pieces = @white_pieces
      king = @black_king
    end

    return opponent_pieces.any? do |piece|
      piece.moves.include?(king.position)
    end
  end

  def check_mate?(color)
    return false unless in_check?(color)
    possible_moves = []
    color == "white" ? current_color = @white_pieces : current_color = @black_pieces
    current_color.each do |piece|
      possible_moves.concat(piece.valid_moves?)
      return false unless possible_moves.empty?
    end
    puts "End Game"
    true
  end

  def deep_dup
    board_dup = Board.new(false)
    #board_dup = self.dup
    @board.each_with_index do |row, row_idx|
      row.each_with_index do |piece, piece_idx|
        if piece.nil?
          board_dup[[row_idx, piece_idx]] = nil
        else
          new_piece = piece.deep_dup(board = board_dup)
          board_dup[[row_idx, piece_idx]] = new_piece
          if new_piece.color == "white"
            board_dup.white_pieces << new_piece
            board_dup.white_king = new_piece if new_piece.class == King
          else
            board_dup.black_pieces << new_piece
            board_dup.black_king = new_piece if new_piece.class == King
          end
        end
      end
    end
    board_dup
  end

end
