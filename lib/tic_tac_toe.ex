defmodule TicTacToe do
  defmodule Game do
    defstruct board: {:blank, :blank, :blank, :blank, :blank, :blank, :blank, :blank, :blank},
              dimension: 3
  end

  def start, do: %Game{}

  def winner(%Game{board: {x, x, x,
                           _, _, _,
                           _, _, _}}) when x != :blank, do: x
  def winner(%Game{board: {_, _, _,
                           x, x, x,
                           _, _, _}}) when x != :blank, do: x
  def winner(%Game{board: {_, _, _,
                           _, _, _,
                           x, x, x}}) when x != :blank, do: x
  def winner(%Game{board: {x, _, _,
                           x, _, _,
                           x, _, _}}) when x != :blank, do: x
  def winner(%Game{board: {_, x, _,
                           _, x, _,
                           _, x, _}}) when x != :blank, do: x
  def winner(%Game{board: {_, _, x,
                           _, _, x,
                           _, _, x}}) when x != :blank, do: x
  def winner(%Game{board: {x, _, _,
                           _, x, _,
                           _, _, x}}) when x != :blank, do: x
  def winner(%Game{board: {_, _, x,
                           _, x, _,
                           x, _, _}}) when x != :blank, do: x
  def winner(%Game{}), do: nil

  def won?(game), do: winner(game) != nil
  
  def cats_game?(game) do
    if winner(game) do
      false
    else
      game |> locations |> Enum.all?(fn(loc) -> !blank?(game, loc) end)
    end
  end

  def game_over?(game) do
    won?(game) or cats_game?(game)
  end

  def blank?(game, {x, y}) do
    get_mark_at(game, {x, y}) == :blank
  end

  def claim(game, {x, y}, mark) do
    if blank?(game, {x, y}) do
      {:ok, set_mark_at(game, {x, y}, mark)}
    else
      {:error, game}
    end
  end

  def locations(game) do
    range = 0..(game.dimension - 1)
    Enum.flat_map(range, fn(x) -> Enum.map(range, fn(y) -> {x, y} end) end)
  end

  defp get_mark_at(game, {x, y}) do
    index = x * game.dimension + y
    elem(game.board, index)
  end

  defp set_mark_at(game, {x, y}, mark) do
    index = x * game.dimension + y
    %Game{game | board: put_elem(game.board, index, mark) }
  end
end
