defmodule TicTacToe.Server do
  use GenServer

  alias TicTacToe.{Game, Server}

  def init(_) do
    { :ok, %Game{} }
  end

  def handle_call({:claim, location}, _, game) do
    case Game.claim(game, location) do
      {:ok, game} ->
        {:reply, {:ok, game}, game}
      {:error, game} ->
        {:reply, {:error, "Unable to make that move"}, game}
    end
  end

  def handle_call({:game_over?}, _, game) do
    {:reply, Game.game_over?(game), game}
  end

  def handle_call({:get_board}, _, game) do
    {:reply, game.board, game}
  end

  def start do
    GenServer.start(Server, nil)
  end

  def claim(pid, location) do
    GenServer.call(pid, {:claim, location})
  end

  def game_over?(pid) do
    GenServer.call(pid, {:game_over?})
  end

  def get_board(pid) do
    GenServer.call(pid, {:get_board})
  end
end
