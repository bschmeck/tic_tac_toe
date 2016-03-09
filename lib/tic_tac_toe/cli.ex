defmodule TicTacToe.CLI do
  alias TicTacToe.{Board, CLI, Game}

  def loop(game) do
    print_board(game)
    if Game.game_over? game do
      IO.puts "GAME OVER"
    else
      move = get_move
      IO.puts
      case Game.claim(game, move) do
        {:ok, game} ->
          loop(game)
        {:error, game} ->
          IO.puts "Unable to make that move."
          loop(game)
      end
    end
  end

  def get_move do
    case IO.gets("Move: ")
    |> String.rstrip
    |> String.upcase
    |> location_from_input do

      {:ok, move} -> move
      
      {:error} ->
        IO.puts "Invalid move."
        get_move
    end
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

  defp location_from_input("A1"), do: {:ok, { 0, 0 } }
  defp location_from_input("A2"), do: {:ok, { 1, 0 } }
  defp location_from_input("A3"), do: {:ok, { 2, 0 } }
  defp location_from_input("B1"), do: {:ok, { 0, 1 } }
  defp location_from_input("B2"), do: {:ok, { 1, 1 } }
  defp location_from_input("B3"), do: {:ok, { 2, 1 } }
  defp location_from_input("C1"), do: {:ok, { 0, 2 } }
  defp location_from_input("C2"), do: {:ok, { 1, 2 } }
  defp location_from_input("C3"), do: {:ok, { 2, 2 } }
  defp location_from_input(_), do: {:error}
end
