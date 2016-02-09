defmodule TicTacToe do
  def start, do: {:blank, :blank, :blank, :blank, :blank, :blank, :blank, :blank, :blank}

  def winner({x, x, x, _, _, _, _, _, _}) when x != :blank, do: x
  def winner({_, _, _, x, x, x, _, _, _}) when x != :blank, do: x
  def winner({_, _, _, _, _, _, x, x, x}) when x != :blank, do: x
  def winner({x, _, _, x, _, _, x, _, _}) when x != :blank, do: x
  def winner({_, x, _, _, x, _, _, x, _}) when x != :blank, do: x
  def winner({_, _, x, _, _, x, _, _, x}) when x != :blank, do: x
  def winner({x, _, _, _, x, _, _, _, x}) when x != :blank, do: x
  def winner({_, _, x, _, x, _, x, _, _}) when x != :blank, do: x
  def winner(_board), do: nil

  def cats_game?(board) do
    if winner(board) do
      false
    else
      board |> locations |> Enum.all?(fn(loc) -> !blank?(board, loc) end)
    end
  end

  def game_over?(board) do
    winner(board) != nil
  end

  def blank?(board, {x, y}) do
    get_mark_at(board, {x, y}) == :blank
  end

  def claim(board, {x, y}, mark) do
    if blank?(board, {x, y}) do
      {:ok, set_mark_at(board, {x, y}, mark)}
    else
      {:error, board}
    end
  end

  def locations(board) do
    range = 0..(dimension(board) - 1)
    Enum.flat_map(range, fn(x) -> Enum.map(range, fn(y) -> {x, y} end) end)
  end

  defp dimension(board), do: board |> tuple_size |> :math.sqrt |> trunc

  defp get_mark_at(board, {x, y}) do
    index = x * dimension(board) + y
    elem(board, index)
  end

  defp set_mark_at(board, {x, y}, mark) do
    index = x * dimension(board) + y
    put_elem(board, index, mark)
  end
end
