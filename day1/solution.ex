defmodule Solution do
  @file_path "./input.txt"

  def part_one() do
    @file_path
    |> File.stream!()
    |> Stream.chunk_while([], fn line, acc -> chunk_fun(line, acc) end, fn acc ->
      after_fun(acc)
    end)
    |> Enum.max()
    |> Enum.at(0)
  end

  def part_two() do
    @file_path
    |> File.stream!()
    |> Stream.chunk_while([], fn line, acc -> chunk_fun(line, acc) end, fn acc ->
      after_fun(acc)
    end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> List.flatten()
    |> Enum.sum()
  end

  defp clean_line(line) do
    line |> String.replace("\n", "") |> Integer.parse() |> elem(0)
  end

  defp chunk_fun(line, acc) do
    if line == "\n" do
      {:cont, [Enum.sum(acc)], []}
    else
      {:cont, [clean_line(line) | acc]}
    end
  end

  defp after_fun(acc) do
    {:cont, acc}
  end
end

Solution.part_one() |> IO.inspect()

Solution.part_two() |> IO.inspect()
