defmodule TicTacToe.ServerTest do
  use ExUnit.Case, async: true
  doctest TicTacToe.Server
  alias TicTacToe.{Board, Game, Server}

  setup do
    {:ok, server} = Server.start
    {:ok, server: server}
  end

  test "join assigns a player", %{server: server} do
    assert :x = Server.join(server)
  end

  test "whoami returns the player's mark", %{server: server} do
    mark = Server.join(server)
    assert ^mark = Server.whoami?(server)
  end

  test "claim marks a location", %{server: server} do
    Server.join(server)
    loc = {0, 0}
    assert {:ok, _game} = Server.claim(server, loc)
    refute server |> Server.get_board |> Board.blank?(loc)
  end

  test "claim enforces turn taking", %{server: server} do
    Server.join(server)
    assert {:ok, _game} = Server.claim(server, {0, 0})
    assert {:error, _message} = Server.claim(server, {0, 1})
  end
end
