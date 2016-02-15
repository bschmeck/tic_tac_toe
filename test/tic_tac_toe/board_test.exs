defmodule TicTacToe.BoardTest do
  use ExUnit.Case
  doctest TicTacToe.Board
  alias TicTacToe.Board

  test "all spots are blank on a new board" do
    board = %Board{}
    assert board |>
      Board.locations |>
      Enum.all?(fn(loc) -> Board.blank? board, loc end)
  end

  test "after setting a mark, a spot is not blank" do
    loc = { 1, 1 }
    board = %Board{} |> Board.set_mark_at(loc, :x)
    refute Board.blank?(board, loc)
  end

  test "a previously claimed spot cannot be claimed" do
    loc = {1, 0}
    board = %Board{} |> Board.set_mark_at(loc, :x)
    assert {:error, board} == Board.set_mark_at(board, loc, :o)
  end

  test "a board with blank locations is not full" do
    board = %Board{ spots: {:x, :x, :o, :o, :x, :o, :x, :o, :blank} }
    refute Board.full?(board)
  end

  test "a board without blank locations is full" do
    board = %Board{ spots: {:x, :x, :o, :o, :x, :o, :x, :o, :o} }
    assert Board.full?(board)
  end

  test "rows returns each row from the board" do
    rows = %Board{ spots: {:x, :x, :o, :o, :o, :x, :x, :blank, :x} } |> Board.rows
    assert rows == [[:x, :x, :o], [:o, :o, :x], [:x, :blank, :x]]
  end
end
