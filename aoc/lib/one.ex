defmodule One do
  @moduledoc """
  Day one
  """

  alias Utils

  def part_one() do
    Utils.input!(1)
    |> Stream.chunk_while([], &chunk_fun/2, &after_fun/1)
    |> Enum.to_list()
    |> Enum.max()
  end

  def part_two() do
    Utils.input!(1)
    |> Stream.chunk_while([], &chunk_fun/2, &after_fun/1)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end

  defp chunk_fun("", acc), do: {:cont, Enum.sum(acc), []}
  defp chunk_fun(line, acc), do: {:cont, [String.to_integer(line) | acc]}

  defp after_fun(acc), do: {:cont, acc}
end
