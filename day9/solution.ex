defmodule Solution do
  @file_path "./input.txt"
  @regex ~r/^(?<direction>[LRUD]) (?<steps>[0-9]+)/

  def part_one(knots) do
    @file_path
    |> File.stream!()
    |> make_moves(knots)
    |> count_tail_places()
  end

  defp make_moves(stream, knots) do
    Enum.reduce(stream, initial_state(knots), &parse_line/2)
  end

  defp initial_state(_knots_amount) do
    %{
      tail_places: MapSet.new([{0, 0}]),
      coordinates: %{
        head: {0, 0},
        tail: {0, 0}
      }
    }
  end

  defp count_tail_places(%{tail_places: tail_places}), do: MapSet.size(tail_places)

  defp parse_line(line, state) do
    {direction, steps} = extract_instructions(line)
    move_rope(direction, steps, state)
  end

  defp move_rope(_direction, 0, state), do: state

  defp move_rope(direction, steps, %{coordinates: coordinates} = state) do
    new_head_position = move_axis(coordinates.head, direction)

    coordinates = Map.update!(coordinates, :head, fn _x -> new_head_position end)
    new_state = update_coordinates(state, coordinates)
    new_state = maybe_update_tail(new_state)
    move_rope(direction, steps - 1, new_state)
  end

  defp update_coordinates(state, new_coordinates) do
    Map.update!(state, :coordinates, fn _ -> new_coordinates end)
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

  defp move_tail(%{coordinates: %{head: {head_x, head_y}, tail: {tail_x, tail_y}} = coordinates,
         tail_places: tail_places}
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

    %{
      coordinates: Map.update!(coordinates, :tail, fn _x -> new_tail_axis end),
      tail_places: MapSet.put(tail_places, new_tail_axis)
    }
  end

  defp maybe_update_tail(%{coordinates: coordinates} = state) do
    if adjacent?(coordinates.head, coordinates.tail) do
      state
    else
      move_tail(state)
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

Solution.part_one(2) |> IO.inspect(label: "tail visited this many positions")
# 6004 too low
# 6030 is right
