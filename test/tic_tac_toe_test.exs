defmodule TicTacToeTest do
  use ExUnit.Case
  doctest TicTacToe

  test "a new game is not over" do
    refute TicTacToe.start |> TicTacToe.game_over?
  end

  test "all spots are blank on a new board" do
    game = TicTacToe.start
    assert game |>
      TicTacToe.locations |>
      Enum.all?(fn(loc) -> TicTacToe.blank? game, loc end)
  end

  test "after claiming, a spot is not blank" do
    loc = { 1, 1 }
    {:ok, game} = TicTacToe.start |> TicTacToe.claim(loc, :x)
    refute TicTacToe.blank?(game, loc)
  end

  test "a previously claimed spot cannot be claimed" do
    loc = {1, 0}
    {:ok, game} = TicTacToe.start |> TicTacToe.claim(loc, :x)
    assert {:error, game} == TicTacToe.claim(game, loc, :o)
  end

  test "a board with blank locations is not a cat's game" do
    game = %TicTacToe.Game{board: {:x, :x, :o, :o, :x, :o, :x, :o, :blank} }
    refute TicTacToe.cats_game?(game)
  end

  test "a winning board is not a cat's game" do
    game = %TicTacToe.Game{board: {:x, :x, :o, :o, :x, :o, :x, :o, :o} }
    assert TicTacToe.winner(game)
    refute TicTacToe.cats_game?(game)
  end

  test "a cat's game is a cat's game" do
    game = %TicTacToe.Game{board: {:x, :x, :o, :o, :o, :x, :x, :o, :x} }
    refute TicTacToe.winner(game)
    assert TicTacToe.cats_game?(game)
  end

  test "cat's games are over" do
    game = %TicTacToe.Game{ board: {:x, :x, :o, :o, :o, :x, :x, :o, :x} }
    assert TicTacToe.cats_game?(game)
    assert TicTacToe.game_over?(game)
  end
end
