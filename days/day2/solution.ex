defmodule SolutionPartOne do
  @file_path "./input.txt"

  def run() do
    @file_path
    |> File.stream!()
    |> Enum.reduce(0, fn line, acc -> acc + sum_line(line) end)
  end

  def sum_line(line) do
    line |> String.replace("\n", "") |> String.split(" ") |> calc_points()
  end

  # A (Rock) B (Paper) C (Scissors)
  # X (Rock) Y (Paper) Z (Scissors)
  # Winning is 6, Drawing is 3, Losing is 0
  # Using Rock is 1, using Paper is 2, using Scissors is 3

  defp calc_points(["A", "X"]), do: 3 + 1
  defp calc_points(["A", "Y"]), do: 6 + 2
  defp calc_points(["A", "Z"]), do: 0 + 3
  defp calc_points(["B", "X"]), do: 0 + 1
  defp calc_points(["B", "Y"]), do: 3 + 2
  defp calc_points(["B", "Z"]), do: 6 + 3
  defp calc_points(["C", "X"]), do: 6 + 1
  defp calc_points(["C", "Y"]), do: 0 + 2
  defp calc_points(["C", "Z"]), do: 3 + 3
end

defmodule SolutionPartTwo do
  @file_path "./input.txt"

  def run() do
    @file_path
    |> File.stream!()
    |> Enum.reduce(0, fn line, acc -> acc + sum_line(line) end)
  end

  def sum_line(line) do
    line |> String.replace("\n", "") |> String.split(" ") |> calc_points()
  end

  # A (Rock) B (Paper) C (Scissors)
  # X (You have to lose) Y (You have to draw) Z (You have to win)
  # Winning is 6, Drawing is 3, Losing is 0
  # Using Rock is 1, using Paper is 2, using Scissors is 3

  defp calc_points(["A", "X"]), do: 0 + 3
  defp calc_points(["A", "Y"]), do: 3 + 1
  defp calc_points(["A", "Z"]), do: 6 + 2
  defp calc_points(["B", "X"]), do: 0 + 1
  defp calc_points(["B", "Y"]), do: 3 + 2
  defp calc_points(["B", "Z"]), do: 6 + 3
  defp calc_points(["C", "X"]), do: 0 + 2
  defp calc_points(["C", "Y"]), do: 3 + 3
  defp calc_points(["C", "Z"]), do: 6 + 1
end

SolutionPartOne.run() |> IO.inspect()

SolutionPartTwo.run() |> IO.inspect()
