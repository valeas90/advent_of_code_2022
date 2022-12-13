defmodule Solution do
  @file_path "./input.txt"

  def part_one() do
    @file_path
    |> File.read!()
    |> parse()
    |> find_shortest_path()
  end

  def part_two() do
    @file_path
    |> File.read!()
    |> parse()
    |> find_shortest_path_from_any_a()
  end

  def parse(input) do
    heightmap =
      input
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.codepoints/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        row |> Enum.with_index() |> Enum.map(fn {el, x} -> {{x, y}, el} end)
      end)

    from = heightmap |> Enum.find(heightmap, fn {_, v} -> v == "S" end) |> elem(0)
    to = heightmap |> Enum.find(heightmap, fn {_, v} -> v == "E" end) |> elem(0)
    heights = heightmap |> Enum.map(fn {k, v} -> {k, height(v)} end) |> Map.new()

    {from, to, heights}
  end

  def find_shortest_path({from, to, heights}) do
    heights
    |> Map.keys()
    |> Map.new(fn key -> {key, :infinity} end)
    |> Map.put(from, 0)
    |> dijkstra(heights, to)
  end

  def find_shortest_path_from_any_a({_from, to, heights}) do
    heights
    |> Map.keys()
    |> Map.new(fn key -> {key, :infinity} end)
    |> initialized_distances(heights)
    |> dijkstra(heights, to)
  end

  def initialized_distances(distances, heights) do
    heights
    |> Enum.filter(fn {_key, height} -> height == 0 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(distances, &Map.put(&2, &1, 0))
  end

  def dijkstra(distances, heights, dst) do
    case Enum.min_by(distances, &elem(&1, 1)) do
      {^dst, dist} ->
        dist

      {cur, dist} ->
        cur
        |> neighbours(heights)
        |> Enum.reduce(distances, fn neighbour, acc ->
          Map.replace(acc, neighbour, min(acc[neighbour], dist + 1))
        end)
        |> Map.delete(cur)
        |> dijkstra(heights, dst)
    end
  end

  def neighbours({x, y}, heights) do
    h = heights[{x, y}]
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}] |> Enum.filter(&(heights[&1] <= h + 1))
  end

  def height("E"), do: height("z")
  def height("S"), do: height("a")
  def height(<<c>>), do: c - ?a
end

Solution.part_one() |> IO.inspect(label: "part one")

Solution.part_two() |> IO.inspect(label: "part two")
