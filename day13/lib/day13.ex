defmodule Day13 do
  @file_path "./input.txt"

  def part_one() do
    @file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(fn line -> line == "" end)
    |> Enum.map(&JSON.decode!/1)
    |> Enum.chunk_every(2)
    |> Enum.with_index(1)
    |> Enum.map(fn {[left, right], index} -> if compare(left, right), do: index, else: 0 end)
    |> Enum.sum()
  end

  def part_two() do
    @file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(fn line -> line == "" end)
    |> Enum.concat(["[[2]]", "[[6]]"])
    |> Enum.map(&JSON.decode!/1)
    |> Enum.sort(&compare/2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {packet, _index} -> packet == [[2]] or packet == [[6]] end)
    |> then(fn [{_x, x_index}, {_y, y_index}] -> x_index * y_index end)
  end

  defp compare(x, x) when is_integer(x), do: :continue
  defp compare(x, y) when is_integer(x) and is_integer(y), do: x < y
  defp compare(x, y) when is_integer(x), do: compare([x], y)
  defp compare(x, y) when is_integer(y), do: compare(x, [y])

  defp compare(x, y) when is_list(x) and is_list(y) do
    x = Stream.concat(x, [:stop])
    y = Stream.concat(y, [:stop])

    Enum.zip_reduce(x, y, :continue, fn left, right, acc -> result(left, right, acc) end)
  end

  defp result(_, _, false), do: false
  defp result(_, _, true), do: true
  defp result(:stop, :stop, _), do: :continue
  defp result(:stop, _, _), do: true
  defp result(_, :stop, _), do: false
  defp result(left, right, :continue), do: compare(left, right)
end

Day13.part_one() |> IO.inspect(label: "part one")

Day13.part_two() |> IO.inspect(label: "part two")
