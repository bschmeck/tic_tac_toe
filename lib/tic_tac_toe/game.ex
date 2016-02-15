defmodule TicTacToe.Game do
  alias TicTacToe.{Board, Game}

  defstruct board: %Board{},
            turn: :x
  
  def start, do: %Game{}

  def won?(%Game{board: board}), do: Board.three_in_a_row?(board)
  
  def cats_game?(%Game{board: board} = game) do
    if won?(game) do
      false
    else
      Board.full?(board)
    end
  end

  def game_over?(game) do
    won?(game) or cats_game?(game)
  end

  def claim(%Game{turn: :x} = game, loc) when tuple_size(loc) == 2, do: claim(game, loc, :o)
  def claim(%Game{turn: :o} = game, loc) when tuple_size(loc) == 2, do: claim(game, loc, :x)
  defp claim(%Game{turn: mark, board: board} = game, loc, next_turn) do
    if Board.blank?(board, loc) do
      game = %Game{ game | board: Board.set_mark_at(board, loc, mark), turn: next_turn}
      
      {:ok, game}
    else
      {:error, game}
    end
  end
end
