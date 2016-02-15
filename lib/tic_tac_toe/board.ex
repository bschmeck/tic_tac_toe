defmodule TicTacToe.Board do
  alias TicTacToe.Board

  defstruct spots: {:blank, :blank, :blank, :blank, :blank, :blank, :blank, :blank, :blank},
            dimension: 3

  def winner(%Board{spots: {x, x, x,
                            _, _, _,
                            _, _, _}}) when x != :blank, do: x
  def winner(%Board{spots: {_, _, _,
                            x, x, x,
                            _, _, _}}) when x != :blank, do: x
  def winner(%Board{spots: {_, _, _,
                            _, _, _,
                            x, x, x}}) when x != :blank, do: x
  def winner(%Board{spots: {x, _, _,
                            x, _, _,
                            x, _, _}}) when x != :blank, do: x
  def winner(%Board{spots: {_, x, _,
                            _, x, _,
                            _, x, _}}) when x != :blank, do: x
  def winner(%Board{spots: {_, _, x,
                            _, _, x,
                            _, _, x}}) when x != :blank, do: x
  def winner(%Board{spots: {x, _, _,
                            _, x, _,
                            _, _, x}}) when x != :blank, do: x
  def winner(%Board{spots: {_, _, x,
                            _, x, _,
                            x, _, _}}) when x != :blank, do: x
  def winner(%Board{}), do: nil

  def three_in_a_row?(board), do: winner(board) != nil

  def full?(board) do
    board |> locations |> Enum.all?(fn(loc) -> !blank?(board, loc) end)
  end

  def blank?(board, loc) when tuple_size(loc) == 2 do
    get_mark_at(board, loc) == :blank
  end

 def locations(%Board{dimension: dimension}) do
    range = 0..(dimension - 1)
    Enum.flat_map(range, fn(x) -> Enum.map(range, fn(y) -> {x, y} end) end)
  end

  def rows(%Board{dimension: dimension} = game) do
    range = 0..(dimension - 1)
    Enum.map(range, fn(x) -> Enum.map(range, fn(y) -> get_mark_at(game, {x, y}) end) end)
  end

  def get_mark_at(%Board{spots: spots, dimension: dimension}, {x, y}) do
    index = x * dimension + y
    elem(spots, index)
  end

  def set_mark_at(%Board{spots: spots, dimension: dimension} = board, {x, y} = loc, mark) do
    if blank?(board, loc) do
      index = x * dimension + y
      %Board{board | spots: put_elem(spots, index, mark)}
    else
      {:error, board}
    end
  end
end
