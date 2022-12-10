defmodule Solution do
  @file_path "./input.txt"
  @addx_cycles 2
  @crt_pixels_width 40

  def part_one() do
    @file_path
    |> File.stream!()
    |> Stream.map(fn line -> String.replace(line, "\n", "") end)
    |> examine_signal()
    |> convert_states_to_map()
    |> sum_strengths()
  end

  def part_two() do
    @file_path
    |> File.stream!()
    |> Stream.map(fn line -> String.replace(line, "\n", "") end)
    |> examine_signal()
    |> convert_states_to_map()
    |> get_drawing_elements()
    |> draw_image()
  end

  defp examine_signal(stream) do
    Enum.map_reduce(stream, %{x: 1, cycles: 0}, &parse_command/2)
  end

  defp convert_states_to_map({states, _last_state}) do
    states
    |> List.flatten()
    |> Enum.reduce(%{}, fn element, acc ->
      Map.put(acc, element.cycles, element.x)
    end)
  end

  defp sum_strengths(states) do
    [20, 60, 100, 140, 180, 220]
    |> Enum.reduce(0, fn cycle, acc ->
      x = Map.get(states, cycle - 1)
      acc + x * cycle
    end)
  end

  defp get_drawing_elements(states) do
    1..240
    |> Enum.map(fn cycle ->
      last_completed_cycle = cycle - 1
      # x is the position of the middle of the 3 pixel-wide sprite
      x = Map.get(states, last_completed_cycle, 1)
      position_to_draw = rem(last_completed_cycle, @crt_pixels_width)
      if abs(x - position_to_draw) <= 1, do: "#", else: "."
    end)
  end

  defp draw_image(dots) do
    dots
    |> Enum.chunk_every(40)
    |> Enum.each(fn dots -> show(dots) end)
  end

  defp show(dots) do
    "#{Enum.join(dots, "")}" |> IO.inspect()
  end

  defp parse_command("noop", acc) do
    {[%{x: acc.x, cycles: acc.cycles + 1}], %{x: acc.x, cycles: acc.cycles + 1}}
  end

  defp parse_command(command, acc) do
    number = command |> String.split("addx ") |> Enum.at(-1) |> String.to_integer()

    new_states =
      Enum.map(1..@addx_cycles, fn execution ->
        if execution < @addx_cycles do
          %{x: acc.x, cycles: acc.cycles + execution}
        else
          %{x: acc.x + number, cycles: acc.cycles + execution}
        end
      end)

    {new_states, %{x: acc.x + number, cycles: acc.cycles + @addx_cycles}}
  end
end

Solution.part_one() |> IO.inspect(limit: :infinity)

Solution.part_two() |> IO.inspect(limit: :infinity)
