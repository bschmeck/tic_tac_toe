defmodule TicTacToe.CLI do
  alias TicTacToe.{Board, CLI, Game}

  def loop(game) do
    print_board(game)
    move = get_move
    {:ok, game} = Game.claim game, move
    if Game.game_over? game do
      print_board(game)
      IO.puts "GAME OVER"
    else
      loop(game)
    end
  end

  def get_move do
    [x, y] = IO.gets("Move: ")
    |> String.rstrip
    |> String.split
    |> Enum.map(fn(s) ->
      {i, _} = Integer.parse(s)
      i - 1
    end)
    {x, y}
  end

  def print_board(game) do
    game.board
    |> Board.rows
    |> Enum.map(&(row_to_s(&1)))
    |> Enum.join(row_separator)
    |> IO.puts
  end

  defp row_to_s(row) do
    row |> Enum.map(&(cell_to_s(&1))) |> Enum.join(cell_separator)
  end

  defp row_separator, do: "\n---|---|---\n"
  defp cell_separator, do: "|"

  defp cell_to_s(:x), do: " X "
  defp cell_to_s(:o), do: " O "
  defp cell_to_s(_), do: "   "
end
