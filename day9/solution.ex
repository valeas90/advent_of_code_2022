defmodule Solution do
  @file_path "./input.txt"
  @starting_point %{head: {0, 0}, tail: {0, 0}}
  @regex ~r/^(?<direction>[LRUD]) (?<steps>[1-9]+)/

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

  defp move_axis({x_axis, y_axis}, direction) do
    case direction do
      :up -> {x_axis + 1, y_axis}
      :down -> {x_axis - 1, y_axis}
      :right -> {x_axis, y_axis + 1}
      :left -> {x_axis, y_axis - 1}
    end
  end

  defp adjacent?({head_x_axis, head_y_axis}, {tail_x_axis, tail_y_axis}) do
    {distance_x_axis, distance_y_axis} = {head_x_axis - tail_x_axis, head_y_axis - tail_y_axis}
    distance_x_axis in [-1, 0, 1] and distance_y_axis in [-1, 0, 1]
  end

  defp move_tail(
         %{head: {head_x_axis, head_y_axis}, tail: {tail_x_axis, tail_y_axis}} = coordinates,
         tail_places
       ) do
    new_tail_axis =
      cond do
        head_x_axis == tail_x_axis ->
          if head_y_axis > tail_y_axis do
            {head_x_axis, head_y_axis - 1}
          else
            {head_x_axis, head_y_axis + 1}
          end

        head_y_axis == tail_y_axis ->
          if head_x_axis > tail_x_axis do
            {head_x_axis - 1, head_y_axis}
          else
            {head_x_axis + 1, head_y_axis}
          end

        true ->
          cond do
            head_x_axis - tail_x_axis == 2 -> {head_x_axis - 1, head_y_axis}
            head_x_axis - tail_x_axis == -2 -> {head_x_axis + 1, head_y_axis}
            head_y_axis - tail_y_axis == 2 -> {head_x_axis, head_y_axis - 1}
            head_y_axis - tail_y_axis == -2 -> {head_x_axis, head_y_axis + 1}
          end
      end

    IO.inspect(
      "moving tail from #{inspect({tail_x_axis, tail_y_axis})} to #{inspect(new_tail_axis)}"
    )

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
