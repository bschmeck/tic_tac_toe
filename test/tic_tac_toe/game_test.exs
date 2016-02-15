defmodule TicTacToe.GameTest do
  use ExUnit.Case
  doctest TicTacToe.Game
  alias TicTacToe.{Board, Game}

  test "a new game is not over" do
    refute Game.start |> Game.game_over?
  end

  test "claiming a spot changes the next mark to be placed" do
    loc = { 1, 1 }
    game = Game.start
    first_mark = game.turn
    {:ok, game} = game |> Game.claim(loc)
    assert game.turn != first_mark
  end

  test "a previously claimed spot cannot be claimed" do
    loc = {1, 0}
    {:ok, game} = Game.start |> Game.claim(loc)
    assert {:error, game} == Game.claim(game, loc)
  end

  test "a board with blank locations is not a cat's game" do
    game = %Game{board: %Board{spots: {:x, :x, :o, :o, :x, :o, :x, :o, :blank} } }
    refute Game.cats_game?(game)
  end

  test "a winning board is not a cat's game" do
    game = %Game{board: %Board{spots: {:x, :x, :o, :o, :x, :o, :x, :o, :o} } }
    assert Game.won?(game)
    refute Game.cats_game?(game)
  end

  test "a cat's game is a cat's game" do
    game = %Game{board: %Board{spots: {:x, :x, :o, :o, :o, :x, :x, :o, :x} } }
    assert Game.cats_game?(game)
  end

  test "cat's games are over" do
    game = %Game{ board: %Board{spots: {:x, :x, :o, :o, :o, :x, :x, :o, :x} } }
    assert Game.cats_game?(game)
    assert Game.game_over?(game)
  end
end
