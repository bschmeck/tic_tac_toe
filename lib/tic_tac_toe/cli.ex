defmodule TicTacToe.CLI do
  alias TicTacToe.{Board, Server}

  def play do
    {:ok, server} = Server.start
    loop(server)
  end

  def loop(server) do
    server |> Server.get_board |> print_board

    if Server.game_over? server do
      IO.puts "GAME OVER"
    else
      move = get_move
      IO.puts ""
      case Server.claim(server, move) do
        {:ok, _} ->
          loop(server)
        {:error, message} ->
          IO.puts message
          loop(server)
      end
    end
  end

  def get_move do
    case IO.gets("Move: ")
         |> normalize_input
         |> location_from_input do

           {:ok, move} -> move
      
           {:error} ->
               IO.puts "Invalid move."
               get_move
         end
  end

  def normalize_input(string) do
    string
    |> String.rstrip
    |> String.replace(" ", "")
    |> String.upcase
    |> String.codepoints
    |> Enum.sort
    |> Enum.join
  end

  def print_board(board) do
    IO.puts header_row
    board
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

  defp location_from_input("1A"), do: {:ok, { 0, 0 } }
  defp location_from_input("2A"), do: {:ok, { 1, 0 } }
  defp location_from_input("3A"), do: {:ok, { 2, 0 } }
  defp location_from_input("1B"), do: {:ok, { 0, 1 } }
  defp location_from_input("2B"), do: {:ok, { 1, 1 } }
  defp location_from_input("3B"), do: {:ok, { 2, 1 } }
  defp location_from_input("1C"), do: {:ok, { 0, 2 } }
  defp location_from_input("2C"), do: {:ok, { 1, 2 } }
  defp location_from_input("3C"), do: {:ok, { 2, 2 } }
  defp location_from_input(_), do: {:error}
end
