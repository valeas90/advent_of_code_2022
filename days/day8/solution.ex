defmodule Solution do
  @file_path "./input.txt"
  @rows_and_columns 99
  @size @rows_and_columns - 1

  def part_one() do
    @file_path
    |> File.stream!()
    |> Stream.with_index()
    |> to_coordinates()
    |> get_visible_trees()
  end

  def part_two() do
    @file_path
    |> File.stream!()
    |> Stream.with_index()
    |> to_coordinates()
    |> calc_scenic_scores()
    |> List.flatten()
    |> Enum.max()
  end

  defp to_coordinates(stream) do
    Enum.reduce(stream, %{}, fn {line, index}, acc -> add_line(line, index, acc) end)
  end

  defp add_line(line, index, coordinates) do
    line
    |> String.replace("\n", "")
    |> String.graphemes()
    |> Enum.map(&String.to_integer(&1))
    |> Enum.with_index()
    |> Enum.reduce(coordinates, fn {number, column}, acc ->
      Map.put(acc, {index, column}, number)
    end)
  end

  defp get_visible_trees(coordinates) do
    Enum.map(0..@size, fn x_axis ->
      Enum.reduce(0..@size, 0, fn y_axis, acc ->
        if visible?(x_axis, y_axis, coordinates), do: acc + 1, else: acc
      end)
    end)
    |> Enum.sum()
  end

  defp calc_scenic_scores(coordinates) do
    Enum.map(0..@size, fn x_axis ->
      Enum.map(0..@size, fn y_axis -> calc_scenic_score({x_axis, y_axis}, coordinates) end)
    end)
  end

  defp calc_scenic_score(position, coordinates) do
    height = Map.get(coordinates, position)

    count(height, move_axis(position, :north), coordinates, :north, 0) *
      count(height, move_axis(position, :east), coordinates, :east, 0) *
      count(height, move_axis(position, :south), coordinates, :south, 0) *
      count(height, move_axis(position, :west), coordinates, :west, 0)
  end

  defp count(_height, {-1, _y_axis}, _coordinates, _cardinality, acc), do: acc
  defp count(_height, {@rows_and_columns, _y_axis}, _coordinates, _cardinality, acc), do: acc
  defp count(_height, {_x_axis, -1}, _coordinates, _cardinality, acc), do: acc
  defp count(_height, {_x_axis, @rows_and_columns}, _coordinates, _cardinality, acc), do: acc

  defp count(height, new_position, coordinates, cardinality, acc) do
    if height > Map.get(coordinates, new_position) do
      count(height, move_axis(new_position, cardinality), coordinates, cardinality, acc + 1)
    else
      acc + 1
    end
  end

  defp visible?(x_axis, _y_axis, _coordinates) when x_axis == 0 or x_axis == @size, do: true
  defp visible?(_x_axis, y_axis, _coordinates) when y_axis == 0 or y_axis == @size, do: true

  defp visible?(x_axis, y_axis, coordinates) do
    height = Map.get(coordinates, {x_axis, y_axis})

    Enum.any?([
      visible_from?(height, move_axis({x_axis, y_axis}, :north), coordinates, :north),
      visible_from?(height, move_axis({x_axis, y_axis}, :east), coordinates, :east),
      visible_from?(height, move_axis({x_axis, y_axis}, :south), coordinates, :south),
      visible_from?(height, move_axis({x_axis, y_axis}, :west), coordinates, :west)
    ])
  end

  defp visible_from?(_height, {-1, _y_axis}, _coordinates, _cardinality), do: true
  defp visible_from?(_height, {@rows_and_columns, _y_axis}, _coordinates, _cardinality), do: true
  defp visible_from?(_height, {_x_axis, -1}, _coordinates, _cardinality), do: true
  defp visible_from?(_height, {_x_axis, @rows_and_columns}, _coordinates, _cardinality), do: true

  defp visible_from?(height, new_position, coordinates, cardinality) do
    if height > Map.get(coordinates, new_position) do
      visible_from?(height, move_axis(new_position, cardinality), coordinates, cardinality)
    else
      false
    end
  end

  defp move_axis({x_axis, y_axis}, :north), do: {x_axis - 1, y_axis}
  defp move_axis({x_axis, y_axis}, :east), do: {x_axis, y_axis + 1}
  defp move_axis({x_axis, y_axis}, :south), do: {x_axis + 1, y_axis}
  defp move_axis({x_axis, y_axis}, :west), do: {x_axis, y_axis - 1}
end

Solution.part_one() |> IO.inspect(label: "visible trees")

Solution.part_two() |> IO.inspect(label: "tree with highest scenic score")
