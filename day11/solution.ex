defmodule Solution do
  @rounds 20

  def part_one() do
    operations = %{
      "0" => fn old -> old * 19 end,
      "1" => fn old -> old + 6 end,
      "2" => fn old -> old * old end,
      "3" => fn old -> old + 3 end
    }

    tests = %{
      "0" => fn new -> if rem(new, 23) == 0, do: "2", else: "3" end,
      "1" => fn new -> if rem(new, 19) == 0, do: "2", else: "0" end,
      "2" => fn new -> if rem(new, 13) == 0, do: "1", else: "3" end,
      "3" => fn new -> if rem(new, 17) == 0, do: "0", else: "1" end
    }

    monkeys = %{
      "0" => [79, 98],
      "1" => [54, 65, 75, 74],
      "2" => [79, 60, 97],
      "3" => [74],
      "inspections_0" => 0,
      "inspections_1" => 0,
      "inspections_2" => 0,
      "inspections_3" => 0
    }

    play_round(0, monkeys, operations, tests)
  end

  defp play_round(@rounds, monkeys, _operations, _tests), do: monkeys

  defp play_round(rounds, monkeys, operations, tests) do
    monkeys =
      0..3
      |> Enum.reduce(monkeys, fn monkey, acc ->
        monkey = Integer.to_string(monkey)

        acc
        |> Map.get(monkey)
        |> Enum.reduce(acc, fn item, subacc ->
          {new_worry_level, throwed_to} = inspection(item, monkey, operations, tests)

          subacc
          |> Map.update!(monkey, fn [_head | tail] -> tail end)
          |> Map.update!(throwed_to, fn current -> current ++ [new_worry_level] end)
          |> Map.update!("inspections_#{monkey}", fn current -> current + 1 end)
        end)
      end)

    play_round(rounds + 1, monkeys, operations, tests)
  end

  defp inspection(item, monkey, operations, tests) do
    operation = Map.get(operations, monkey)
    test = Map.get(tests, monkey)

    worry_level = item |> operation.() |> Kernel.div(3)
    throw_to = test.(worry_level)

    {worry_level, throw_to}
  end
end

Solution.part_one() |> IO.inspect(limit: :infinity)
