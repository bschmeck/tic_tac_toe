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
  def winner(_board), do: :blank

  def game_over?(board) do
    winner(board) != :blank
  end

  def blank?(board, {x, y}) do
    elem(board, x * 3 + y) == :blank
  end

  def claim(board, {x, y}, mark) do
    if blank?(board, {x, y}) do
      {:ok, put_elem(board, x * 3 + y, mark)}
    else
      {:error, board}
    end
  end

  def locations(board) do
    dimension = board |> tuple_size |> :math.sqrt |> trunc
    range = 0..(dimension - 1)
    Enum.flat_map(range, fn(x) -> Enum.map(range, fn(y) -> {x, y} end) end)
  end
end
