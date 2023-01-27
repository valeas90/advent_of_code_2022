defmodule Solution do
  @file_path "./input.txt"

  def run(chars_amount) do
    @file_path
    |> File.stream!()
    |> Enum.at(0)
    |> find_marker(chars_amount, chars_amount)
  end

  defp find_marker(buffer, chars_amount, position) do
    if is_marker?(slice(buffer, chars_amount)) do
      position
    else
      buffer
      |> move_next()
      |> find_marker(chars_amount, position + 1)
    end
  end

  defp is_marker?(text), do: String.length(text) == length_no_dups(text)

  defp length_no_dups(text), do: text |> String.to_charlist() |> Enum.uniq() |> Enum.count()

  defp slice(buffer, chars_amount), do: String.slice(buffer, 0..(chars_amount - 1))

  defp move_next(buffer), do: binary_part(buffer, 1, byte_size(buffer) - 1)
end

Solution.run(4) |> IO.inspect()

Solution.run(14) |> IO.inspect()
