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
