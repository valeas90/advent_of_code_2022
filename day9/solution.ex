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

  defp initial_state(knots_amount) do
    %{
      tail_places: MapSet.new([{0, 0}]),
      coordinates: %{
        head: {0, 0},
        knots: Enum.map(2..knots_amount, fn _ -> {0, 0} end)
      }
    }
  end

  defp parse_line(line, state) do
    {direction, steps} = extract_instructions(line)
    move_rope(direction, steps, state)
  end

  defp move_rope(_direction, 0, state), do: state

  defp move_rope(direction, steps, %{coordinates: coordinates} = state) do
    head = move_head(coordinates.head, direction)

    {knots, _acc} =
      Enum.map_reduce(coordinates.knots, head, fn follower, followed ->
        position = maybe_move_knot(followed, follower)
        {position, position}
      end)

    tail = Enum.at(knots, -1)

    new_state = %{
      tail_places: MapSet.put(state.tail_places, tail),
      coordinates: %{head: head, knots: knots}
    }

    move_rope(direction, steps - 1, new_state)
  end

  defp move_head({x, y}, direction) do
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

  defp move_tail({head_x, head_y}, {tail_x, tail_y}) do
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
  end

  defp maybe_move_knot(head, tail) do
    if adjacent?(head, tail), do: tail, else: move_tail(head, tail)
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

  defp count_tail_places(%{tail_places: tail_places}), do: MapSet.size(tail_places)
end

Solution.part_one(2) |> IO.inspect(label: "tail visited this many positions when knots is 2")

# Solution.part_one(10) |> IO.inspect(label: "tail visited this many positions when knots is 10")
