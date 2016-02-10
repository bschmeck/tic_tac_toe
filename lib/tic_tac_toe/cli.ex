defmodule TicTacToe.CLI do
  alias TicTacToe.{CLI, Game}

  def print_board(game) do
    IO.puts(Game.rows(game) |> Enum.map(&(row_to_s(&1))) |> Enum.join(row_separator))
  end

  defp row_to_s(row) do
    row |> Enum.map(&(cell_to_s(&1))) |> Enum.join(cell_separator)
  end

  defp row_separator, do: "\n---|---|---\n"
  defp cell_separator, do: "|"

  defp cell_to_s(:blank), do: "   "
  defp cell_to_s(:x), do: " X "
  defp cell_to_s(:o), do: " O "
end
