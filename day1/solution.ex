defmodule Solution do
  @file_path "./input.txt"

  def chunk_fun(line, acc) do
    if line == "\n" do
      {:cont, [Enum.sum(acc)], []}
    else
      {:cont, [clean_line(line) | acc]}
    end
  end

  def after_fun(acc) do
    {:cont, acc}
  end

  def part_one() do
    @file_path
    |> File.stream!()
    |> Stream.chunk_while([], fn line, acc -> chunk_fun(line, acc) end, fn acc ->
      after_fun(acc)
    end)
    |> Enum.max()
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

  def clean_line(line) do
    {number, ""} = line |> String.replace("\n", "") |> Integer.parse()
    number
  end
end

Solution.part_one() |> IO.inspect()

Solution.part_two() |> IO.inspect()
