defmodule Solution do
  @file_path "./input.txt"
  @starting_point %{head: {0, 0}, tail: {0, 0}}
  @regex ~r/^(?<direction>[LRUD]) (?<steps>[0-9]+)/

  def part_one() do
    @file_path
    |> File.stream!()
    |> make_moves()
    |> count_tail_places()
  end

  defp make_moves(stream) do
    stream
    |> Enum.reduce({@starting_point, MapSet.new([{0, 0}])}, fn line, {coordinates, tail_places} ->
      parse_line(line, tail_places, coordinates)
    end)
  end

  defp count_tail_places({_coordinates, tail_places}), do: MapSet.size(tail_places)

  defp parse_line(line, tail_places, coordinates) do
    {direction, steps} = extract_instructions(line)
    IO.inspect("coordinates are #{inspect(coordinates)}. About to move #{steps} to #{direction}")
    move_rope(direction, steps, coordinates, tail_places)
  end

  defp move_rope(_direction, 0, coordinates, tail_places), do: {coordinates, tail_places}

  defp move_rope(direction, steps, coordinates, tail_places) do
    new_head_position = move_axis(coordinates.head, direction)
    coordinates = Map.update!(coordinates, :head, fn _x -> new_head_position end)
    {coordinates, tail_places} = maybe_update_tail(coordinates, tail_places)
    move_rope(direction, steps - 1, coordinates, tail_places)
  end

  defp move_axis({x, y}, direction) do
    case direction do
      :up -> {x, y + 1}
      :down -> {x, y - 1}
      :right -> {x + 1, y}
      :left -> {x - 1, y}
    end
  end

  defp adjacent?({head_x, head_y}, {tail_x, tail_y}) do
    {distance_x, distance_y} = {head_x - tail_x, head_y - tail_y}
    distance_x in [-1, 0, 1] and distance_y in [-1, 0, 1]
  end

  defp move_tail(
         %{head: {head_x, head_y}, tail: {tail_x, tail_y}} = coordinates,
         tail_places
       ) do
    new_tail_axis =
      cond do
        head_x == tail_x ->
          if head_y > tail_y do
            {head_x, head_y - 1}
          else
            {head_x, head_y + 1}
          end

        head_y == tail_y ->
          if head_x > tail_x do
            {head_x - 1, head_y}
          else
            {head_x + 1, head_y}
          end

        true ->
          cond do
            head_x - tail_x == 2 -> {head_x - 1, head_y}
            head_x - tail_x == -2 -> {head_x + 1, head_y}
            head_y - tail_y == 2 -> {head_x, head_y - 1}
            head_y - tail_y == -2 -> {head_x, head_y + 1}
          end
      end

    # IO.inspect("moving tail from #{inspect({tail_x, tail_y})} to #{inspect(new_tail_axis)}")

    {Map.update!(coordinates, :tail, fn _x -> new_tail_axis end),
     MapSet.put(tail_places, new_tail_axis)}
  end

  defp maybe_update_tail(coordinates, tail_places) do
    if adjacent?(coordinates.head, coordinates.tail) do
      {coordinates, tail_places}
    else
      move_tail(coordinates, tail_places)
    end
  end

  defp extract_instructions(line) do
    instructions =
      @regex
      |> Regex.named_captures(line)
      |> IO.inspect()
      |> Map.update!("steps", &String.to_integer(&1))
      |> Map.update!("direction", fn letter ->
        case letter do
          "U" -> :up
          "D" -> :down
          "R" -> :right
          "L" -> :left
        end
      end)

    {instructions["direction"], instructions["steps"]}
  end
end

Solution.part_one() |> IO.inspect(label: "tail visited this many positions")
# 6004 too low
# 6030 is right
