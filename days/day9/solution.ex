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
    (head_x - tail_x) in [-1, 0, 1] and (head_y - tail_y) in [-1, 0, 1]
  end

  defp move_knot({head_x, head_y}, {tail_x, tail_y}) do
    x_diff = head_x - tail_x
    y_diff = head_y - tail_y

    cond do
      abs(x_diff) > 1 and abs(y_diff) > 1 ->
        move_x = if x_diff > 0, do: 1, else: -1
        move_y = if y_diff > 0, do: 1, else: -1
        {tail_x + move_x, tail_y + move_y}

      abs(y_diff) > 1 ->
        move_y = if y_diff > 0, do: 1, else: -1
        {head_x, tail_y + move_y}

      abs(x_diff) > 1 ->
        move_x = if x_diff > 0, do: 1, else: -1
        {tail_x + move_x, head_y}

      true ->
        {tail_x, tail_y}
    end
  end

  defp maybe_move_knot(head, tail) do
    if adjacent?(head, tail), do: tail, else: move_knot(head, tail)
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

Solution.part_one(10) |> IO.inspect(label: "tail visited this many positions when knots is 10")
