defmodule Solution do
  @file_path "./input.txt"
  @start {20, 0}
  @max_line 40
  @max_column 76

  def part_one() do
    @file_path
    |> File.stream!()
    |> Stream.map(fn line -> line |> String.replace("\n", "") |> String.trim() end)
    |> to_heightmap()
    |> find_path(@start, [], [])
    |> improve_path()
  end

  defp to_heightmap(stream) do
    # Return a map with elements like {4, 5} = g
    stream
    |> Enum.map(&String.graphemes(&1))
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, x_axis}, acc ->
      line
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {letter, y_axis}, acc ->
        Map.update(acc, {x_axis, y_axis}, letter, fn _ -> letter end)
      end)
    end)
  end

  def get(heightmap, key), do: Map.get(heightmap, key)

  defp find_path(heightmap, current_position, forbidden, moves) do
    # IO.inspect(current_position, label: "#{get(heightmap, current_position)}")
    if get(heightmap, current_position) == "z" do
      [current_position | moves]
    else
      move(heightmap, current_position, forbidden, moves)
    end
  end

  defp improve_path(moves) do

  end

  defp move(heightmap, current_position, forbidden, moves) do
    available =
      current_position
      |> vectors()
      |> Enum.filter(&inside?/1)
      |> Enum.reject(fn vector -> Enum.member?(moves, vector) end)
      |> Enum.reject(fn vector -> Enum.member?(forbidden, vector) end)
      |> Enum.filter(fn to ->
        valid_destination?(get(heightmap, current_position), get(heightmap, to))
      end)

    # :timer.sleep(1000)
    if available == [] do
      IO.puts("undoing")
      [_head | moves] = moves
      forbidden = [current_position | forbidden]
      find_path(heightmap, Enum.at(moves, 0), forbidden, moves)
    else
      # position = get_best_option(heightmap, available)
      position = Enum.at(available, 0)
      moves = [current_position | moves]
      find_path(heightmap, position, forbidden, moves)
    end
  end

  defp get_best_option(heightmap, available) do
    index =
      available
      |> Enum.map(fn key -> get(heightmap, key) end)
      |> Enum.with_index()
      |> Enum.max()
      |> elem(1)

    Enum.at(available, index)
  end

  defp inside?({x, y}) do
    x >= 0 and x <= @max_line and y >= 0 and y <= @max_column
  end

  defp valid_destination?("z", "E"), do: true
  defp valid_destination?(_other, "E"), do: false
  defp valid_destination?("S", "a"), do: true
  defp valid_destination?("S", _other), do: false

  defp valid_destination?(<<from_cp::utf8>>, <<to_cp::utf8>>) do
    to_cp - from_cp <= 1
  end

  defp vectors({line, column}) do
    [{0, 1}, {1, 0}, {-1, 0}, {0, -1}]
    |> Enum.map(fn {x, y} -> {line + x, column + y} end)
  end
end

moves = Solution.part_one() |> IO.inspect(limit: :infinity)
IO.inspect(Enum.count(moves), label: "amount of steps")
