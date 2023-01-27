defmodule Solution do
  @file_path "./input.txt"
  @regex ~r/^move (?<amount>[0-9]+) from (?<from>[1-9]) to (?<to>[1-9])/
  @cargo %{
    "1" => ["W", "L", "S"],
    "2" => ["Q", "N", "T", "J"],
    "3" => ["J", "F", "H", "C", "S"],
    "4" => ["B", "G", "N", "W", "M", "R", "T"],
    "5" => ["B", "Q", "H", "D", "S", "L", "R", "T"],
    "6" => ["L", "R", "H", "F", "V", "B", "J", "M"],
    "7" => ["M", "J", "N", "R", "W", "D"],
    "8" => ["J", "D", "N", "H", "F", "T", "Z", "B"],
    "9" => ["T", "F", "B", "N", "Q", "L", "H"]
  }

  def part_one() do
    @file_path
    |> File.stream!()
    |> Enum.reduce(@cargo, fn line, cargo -> parse_line_individually(line, cargo) end)
  end

  def part_two() do
    @file_path
    |> File.stream!()
    |> Enum.reduce(@cargo, fn line, cargo -> parse_line_grouped(line, cargo) end)
  end

  defp parse_line_individually(line, cargo) do
    fields = get_fields_from_line(line)
    move_individually(cargo, fields["amount"], fields["from"], fields["to"])
  end

  defp parse_line_grouped(line, cargo) do
    fields = get_fields_from_line(line)
    move_grouped(cargo, fields["amount"], fields["from"], fields["to"])
  end

  defp move_individually(cargo, 0, _from, _to), do: cargo

  defp move_individually(cargo, amount, from, to) do
    [head | tail] = cargo[from]

    cargo =
      cargo
      |> Map.update!(from, fn _x -> tail end)
      |> Map.update!(to, fn current_crate -> [head | current_crate] end)

    move_individually(cargo, amount - 1, from, to)
  end

  defp move_grouped(cargo, amount, from, to) do
    items = Enum.take(cargo[from], amount)

    cargo
    |> Map.update!(from, fn crate -> crate -- items end)
    |> Map.update!(to, fn crate -> [items | crate] |> List.flatten() end)
  end

  defp get_fields_from_line(line) do
    @regex
    |> Regex.named_captures(line)
    |> Map.update!("amount", &String.to_integer(&1))
  end
end

Solution.part_one() |> IO.inspect(label: "cargo status at the end of part one")

Solution.part_two() |> IO.inspect(label: "cargo status at the end of part two")
