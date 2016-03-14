defmodule TicTacToe.Game do
  alias TicTacToe.{Board, Game}

  defstruct board: %Board{},
            turn: :x,
            watchers: [],
            player_x: nil,
            player_o: nil
  
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

  def watch(game, pid), do: {:ok, %Game{ game | watchers: [pid | game.watchers] } }

  def join(%Game{player_x: nil} = game, pid) do
    game = %Game{ game | player_x: pid }
    watch(game, pid)
  end
  def join(%Game{player_x: pid} = game, pid), do: {:ok, game}
  def join(%Game{player_x: _other, player_o: nil} = game, pid) do
    game = %Game{ game | player_o: pid }
    watch(game, pid)
  end
  def join(%Game{player_x: _other, player_o: pid} = game, pid), do: {:ok, game}
  def join(%Game{player_x: _other, player_o: _other2}, _pid), do: {:error, "Both players already joined"}
end
