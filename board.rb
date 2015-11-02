require_relative "piece"

class Board
  attr_accessor :board
  def initialize
    @board = Array.new(8) {Array.new(8)}
    populate_board
  end

  def populate_board
    #white pieces
    @board[0..1].each_with_index do |row, row_idx|
      row.each_index do |square_idx|
        @board[row_idx][square_idx] = Piece.new([row_idx,square_idx])
      end
    end
    #black pieces
    @board[6..7].each_with_index do |row, row_idx|
      row.each_index do |square_idx|
        @board[row_idx + 6][square_idx] = Piece.new([row_idx + 6,square_idx])
      end
    end
  end

  def [](pos)
    @board[pos[0]][pos[1]]
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def move(start_pos, end_pos)
    fail "outside of board" if end_pos.any? {|position| !position.between?(0, 7)}
    fail "no piece at start" if self[start_pos].nil?
    fail "piece can't move like that" unless piece.moves.include?(end_pos)
    piece = self[start_pos]
    piece.position = end_pos
    self[start_pos] = nil
    self[end_pos] = piece
  end

end
