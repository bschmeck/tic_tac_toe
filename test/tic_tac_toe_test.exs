defmodule TicTacToeTest do
  use ExUnit.Case
  doctest TicTacToe

  test "a new game is not over" do
    refute TicTacToe.start |> TicTacToe.game_over?
  end

  test "all spots are blank on a new board" do
    board = TicTacToe.start
    assert board |>
      TicTacToe.locations |>
      Enum.all?(fn(loc) -> TicTacToe.blank? board, loc end)
  end

  test "after claiming, a spot is not blank" do
    loc = { 1, 1 }
    {:ok, board} = TicTacToe.start |> TicTacToe.claim(loc, :x)
    refute TicTacToe.blank?(board, loc)
  end

  test "a previously claimed spot cannot be claimed" do
    loc = {1, 0}
    {:ok, board} = TicTacToe.start |> TicTacToe.claim(loc, :x)
    assert {:error, board} == TicTacToe.claim(board, loc, :o)
  end
end
