defmodule Solution do
  @file_path "./input.txt"

  def part_one() do
    @file_path
    |> File.stream!()
    |> Enum.reduce(0, fn line, acc -> sum_line(line) + acc end)
  end

  def part_two() do
    @file_path
    |> File.stream!()
    |> Stream.chunk_every(3)
    |> Enum.reduce(0, fn lines, acc -> sum_chunk(lines) + acc end)
  end

  defp sum_line(line) do
    clean_line = line |> String.replace("\n", "")
    size = byte_size(clean_line)

    left = String.slice(clean_line, 0, div(size, 2))
    left_set = left |> String.graphemes() |> MapSet.new()

    right = String.slice(clean_line, div(size, 2), size)
    right_set = right |> String.graphemes() |> MapSet.new()

    MapSet.intersection(left_set, right_set) |> Enum.at(0) |> get_priority(:first_attempt)
  end

  defp sum_chunk([first, second, third]) do
    first = to_mapset(first)
    second = to_mapset(second)
    third = to_mapset(third)

    first
    |> MapSet.intersection(second)
    |> MapSet.intersection(third)
    |> Enum.at(0)
    |> get_priority(:first_attempt)
  end

  defp to_mapset(element),
    do: String.replace(element, "\n", "") |> String.graphemes() |> MapSet.new()

  defp get_priority(letter, :first_attempt) do
    case :binary.match("abcdefghijklmnopqrstuvwxyz", letter) do
      :nomatch -> get_priority(letter, :second_attempt)
      {priority, _length} -> priority + 1
    end
  end

  defp get_priority(letter, :second_attempt) do
    case :binary.match("ABCDEFGHIJKLMNOPQRSTUVWXYZ", letter) do
      :nomatch -> nil
      {priority, _length} -> priority + 27
    end
  end
end

Solution.part_one() |> IO.inspect()

Solution.part_two() |> IO.inspect()
