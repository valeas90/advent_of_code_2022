defmodule Solution do
  @file_path "./input.txt"

  def part_one() do
    @file_path
    |> File.stream!()
    |> Enum.reduce(0, fn line, acc -> maybe_sum_line_full_overlap(line) + acc end)
  end

  def part_two() do
    @file_path
    |> File.stream!()
    |> Enum.reduce(0, fn line, acc -> maybe_sum_line_tiny_overlap(line) + acc end)
  end

  defp maybe_sum_line_full_overlap(line) do
    [first_left, first_right, second_left, second_right] = parse_line(line)
    if full_overlap?(first_left, first_right, second_left, second_right), do: 1, else: 0
  end

  defp maybe_sum_line_tiny_overlap(line) do
    [first_left, first_right, second_left, second_right] = parse_line(line)
    if tiny_overlap?(first_left, first_right, second_left, second_right), do: 1, else: 0
  end

  defp tiny_overlap?(first_left, first_right, second_left, second_right) do
    Enum.any?([
      contains_number?(first_left, first_right, second_left),
      contains_number?(first_left, first_right, second_right),
      contains_number?(second_left, second_right, first_left),
      contains_number?(second_left, second_right, first_right)
    ])
  end

  defp full_overlap?(first_left, first_right, second_left, second_right) do
    Enum.any?([
      second_left >= first_left and second_right <= first_right,
      first_left >= second_left and first_right <= second_right
    ])
  end

  defp contains_number?(from, to, number) do
    number >= from and number <= to
  end

  defp parse_line(line) do
    # receiving "17-19,18-95" would return [17, 19, 18, 95]
    line
    |> String.replace("\n", "")
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> List.flatten()
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
  end
end

Solution.part_one() |> IO.inspect()

Solution.part_two() |> IO.inspect()
