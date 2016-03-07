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
    IO.gets("Move: ")
    |> String.rstrip
    |> String.upcase
    |> location_from_input
  end

  def print_board(game) do
    IO.puts header_row
    game.board
    |> Board.rows
    |> Enum.with_index(1)
    |> Enum.map(&(row_to_s(&1)))
    |> Enum.join(row_separator)
    |> IO.puts
  end

  defp row_to_s({row, index}) do
    cells = row |> Enum.map(&(cell_to_s(&1))) |> Enum.join(cell_separator)
    "#{index_to_s(index)}#{cells}"
  end

  defp row_separator, do: "\n   ---+---+---\n"
  defp cell_separator, do: "|"

  defp cell_to_s(:x), do: " X "
  defp cell_to_s(:o), do: " O "
  defp cell_to_s(_), do: "   "
  defp index_to_s(i), do: " #{i} "

  defp header_row, do: "    A   B   C"

  defp location_from_input("A1"), do: { 0, 0 }
  defp location_from_input("A2"), do: { 1, 0 }
  defp location_from_input("A3"), do: { 2, 0 }
  defp location_from_input("B1"), do: { 0, 1 }
  defp location_from_input("B2"), do: { 1, 1 }
  defp location_from_input("B3"), do: { 2, 1 }
  defp location_from_input("C1"), do: { 0, 2 }
  defp location_from_input("C2"), do: { 1, 2 }
  defp location_from_input("C3"), do: { 2, 2 }
end
