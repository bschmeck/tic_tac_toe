defmodule TicTacToe.Server do
  use GenServer

  alias TicTacToe.{Game, Server}

  def init(_) do
    { :ok, %Game{} }
  end

  def handle_call({:claim, location}, {pid, _ref}, %Game{player_x: x_pid, player_o: o_pid, turn: turn} = game) when (pid == x_pid and turn == :x) or (pid == o_pid and turn == :o) do
    case Game.claim(game, location) do
      {:ok, game} ->
        {:reply, {:ok, game}, game}
      {:error, game} ->
        {:reply, {:error, "Unable to make that move"}, game}
    end
  end
  def handle_call({:claim, _location}, {pid, _ref}, %Game{player_o: o_pid, player_x: x_pid} = game) when pid == x_pid or pid == o_pid do
    {:reply, {:error, "Not your turn"}, game}
  end
  def handle_call({:claim, _location}, _, game) do
    {:reply, {:error, "Not your game"}, game}
  end

  def handle_call({:game_over?}, _, game) do
    {:reply, Game.game_over?(game), game}
  end

  def handle_call({:get_board}, _, game) do
    {:reply, game.board, game}
  end

  def handle_call({:join}, {pid, _ref}, game) do
    case Game.join(game, pid) do
      {:ok, %Game{player_x: ^pid} = game} ->
        {:reply, :x, game}
      {:ok, %Game{player_o: ^pid} = game} ->
        {:reply, :o, game}
      {:error, message} ->
        {:reply, {:error, message}, game}
    end
  end

  def handle_call({:whoami?}, {pid, _ref}, %Game{player_x: pid} = game) do
    {:reply, :x, game}
  end

  def handle_call({:whoami?}, {pid, _ref}, %Game{player_o: pid} = game) do
    {:reply, :o, game}
  end

  def handle_call({:whoami?}, _, game) do
    {:reply, :nobody, game}
  end


  def handle_cast({:inspect}, game) do
    IO.inspect game
    {:noreply, game}
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

  def join(pid) do
    GenServer.call(pid, {:join})
  end

  def whoami?(pid) do
    GenServer.call(pid, {:whoami?})
  end

  def inspect(pid) do
    GenServer.cast(pid, {:inspect})
  end
end
