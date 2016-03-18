defmodule TicTacToe.ServerTest do
  use ExUnit.Case, async: true
  doctest TicTacToe.Server
  alias TicTacToe.{Board, Game, Server}

  setup do
    {:ok, server} = Server.start
    {:ok, server: server}
  end

  test "join assigns a player", %{server: server} do
    spawn fn -> assert :x = Server.join(server) end
    spawn fn -> assert :o = Server.join(server) end
  end

  test "join rejects players if the game is full", %{server: server} do
    player_x = Task.async fn -> Server.join(server) end
    Task.await(player_x)
    player_o = Task.async fn -> Server.join(server) end
    Task.await(player_o)
    assert {:error, _msg} = Server.join(server)
  end

  test "whoami returns the player's mark", %{server: server} do
    mark = Server.join(server)
    assert ^mark = Server.whoami?(server)
  end

  test "whoami returns :nobody if the player hasn't joined", %{server: server} do
    assert :nobody = Server.whoami?(server)
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
