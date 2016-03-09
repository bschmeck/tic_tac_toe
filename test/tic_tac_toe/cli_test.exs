defmodule TicTacToe.CLITest do
  use ExUnit.Case
  doctest TicTacToe.CLI
  alias TicTacToe.CLI
  
  test "normalize_input strips newlines" do
    normalized = "foobar\n" |> CLI.normalize_input
    refute String.contains? normalized, "\n"
  end

  test "normalize removes spaces" do
    normalized = "foo bar" |> CLI.normalize_input
    refute String.contains? normalized, " "
  end

  test "normalize upcases its contents" do
    normalized = "Up" |> CLI.normalize_input
    refute String.contains? normalized, "p"
    assert String.contains? normalized, "P"
  end

  test "normalize sorts the given characters" do
    normalized = "ZFA" |> CLI.normalize_input
    assert normalized == "AFZ"
  end
end
