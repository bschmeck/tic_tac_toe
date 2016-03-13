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

  test "watch adds the given pid to the game's watchers" do
    game = %Game{}
    {:ok, game} = Game.watch(game, self)
    assert Enum.member?(game.watchers, self)
  end

  test "when player_x is unassigned, join assigns the given pid to player_x" do
    game = %Game{}
    {:ok, %Game{player_x: pid}} = Game.join(game, self)
    assert pid == self
  end

  test "when player_x is assigned, join will not assign the same pid to player_o" do
    game = %Game{}
    {:ok, game} = Game.join(game, self)
    {:ok, %Game{player_x: x_pid, player_o: o_pid}} = Game.join(game, self)
    assert x_pid == self
    assert o_pid == nil
  end

  test "when player_x is assigned, join will assign a new pid to player_o" do
    game = %Game{}
    {:ok, game} = Game.join(game, self)
    pid = spawn fn -> 1 end
    {:ok, %Game{player_x: x_pid, player_o: o_pid}} = Game.join(game, pid)
    assert x_pid == self
    assert o_pid == pid
  end

  test "when player_x and player_o are assigned, join will not assign a new pid" do
    game = %Game{}
    {:ok, game} = Game.join(game, self)
    pid = spawn fn -> 1 end
    {:ok, game} = Game.join(game, pid)
    pid2 = spawn fn -> 2 end
    {result, _} = Game.join(game, pid2)
    assert result == :error
  end

  test "join adds player_x to the watchers list" do
    game = %Game{}
    {:ok, %Game{watchers: watchers}} = Game.join(game, self)
    assert Enum.member?(watchers, self)
  end

  test "join adds player_o to the watchers list" do
    game = %Game{}
    {:ok, game} = Game.join(game, self)
    pid = spawn fn -> 1 end
    {:ok, %Game{watchers: watchers}} = Game.join(game, pid)
    assert Enum.member?(watchers, pid)
  end
end
