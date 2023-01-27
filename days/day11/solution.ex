defmodule Solution do
  def part_one() do
    {operations, tests, monkeys} = get_initial_data()
    play_round(20, monkeys, operations, tests, fn origin -> div(origin, 3) end)
  end

  def part_two() do
    {operations, tests, monkeys} = get_initial_data()
    supermodulo = 19 * 13 * 5 * 7 * 17 * 2 * 3 * 11
    play_round(10000, monkeys, operations, tests, fn origin -> rem(origin, supermodulo) end)
  end

  defp get_initial_data() do
    operations = %{
      "0" => fn old -> old * 17 end,
      "1" => fn old -> old + 5 end,
      "2" => fn old -> old + 8 end,
      "3" => fn old -> old + 1 end,
      "4" => fn old -> old + 4 end,
      "5" => fn old -> old * 7 end,
      "6" => fn old -> old + 6 end,
      "7" => fn old -> old * old end
    }

    tests = %{
      "0" => fn new -> if rem(new, 19) == 0, do: "5", else: "3" end,
      "1" => fn new -> if rem(new, 13) == 0, do: "7", else: "6" end,
      "2" => fn new -> if rem(new, 5) == 0, do: "3", else: "0" end,
      "3" => fn new -> if rem(new, 7) == 0, do: "4", else: "5" end,
      "4" => fn new -> if rem(new, 17) == 0, do: "1", else: "6" end,
      "5" => fn new -> if rem(new, 2) == 0, do: "1", else: "4" end,
      "6" => fn new -> if rem(new, 3) == 0, do: "7", else: "2" end,
      "7" => fn new -> if rem(new, 11) == 0, do: "0", else: "2" end
    }

    monkeys = %{
      "0" => [93, 98],
      "1" => [95, 72, 98, 82, 86],
      "2" => [85, 62, 82, 86, 70, 65, 83, 76],
      "3" => [86, 70, 71, 56],
      "4" => [77, 71, 86, 52, 81, 67],
      "5" => [89, 87, 60, 78, 54, 77, 98],
      "6" => [69, 65, 63],
      "7" => [89],
      "inspections_0" => 0,
      "inspections_1" => 0,
      "inspections_2" => 0,
      "inspections_3" => 0,
      "inspections_4" => 0,
      "inspections_5" => 0,
      "inspections_6" => 0,
      "inspections_7" => 0
    }

    {operations, tests, monkeys}
  end

  defp play_round(0, monkeys, _operations, _tests, _reduce_stress_fn), do: monkeys

  defp play_round(rounds, monkeys, operations, tests, reduce_stress_fn) do
    monkeys =
      0..7
      |> Enum.reduce(monkeys, fn monkey, acc ->
        monkey = Integer.to_string(monkey)

        acc
        |> Map.get(monkey)
        |> Enum.reduce(acc, fn item, subacc ->
          {new_worry_level, throwed_to} =
            inspection(item, monkey, operations, tests, reduce_stress_fn)

          subacc
          |> Map.update!(monkey, fn [_head | tail] -> tail end)
          |> Map.update!(throwed_to, fn current -> current ++ [new_worry_level] end)
          |> Map.update!("inspections_#{monkey}", fn current -> current + 1 end)
        end)
      end)

    play_round(rounds - 1, monkeys, operations, tests, reduce_stress_fn)
  end

  defp inspection(item, monkey, operations, tests, reduce_stress_fn) do
    operation = Map.get(operations, monkey)
    test = Map.get(tests, monkey)

    worry_level = item |> operation.() |> reduce_stress_fn.()
    throw_to = test.(worry_level)

    {worry_level, throw_to}
  end
end

Solution.part_one() |> IO.inspect(charlists: true, limit: :infinity)

Solution.part_two() |> IO.inspect(charlists: true, limit: :infinity)
