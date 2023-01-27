defmodule Solution do
  @file_path "./input.txt"

  def part_one() do
    @file_path
    |> File.stream!()
    |> analyze_storage()
    |> find_folders()
  end

  def part_two() do
    @file_path
    |> File.stream!()
    |> analyze_storage()
    |> find_folder_to_remove()
  end

  defp analyze_storage(stream) do
    pwd = "/"
    filesystem = []

    Enum.reduce(stream, {filesystem, pwd}, fn line, acc ->
      {current_filesystem, current_pwd} = acc
      line = String.replace(line, "\n", "")

      if is_command?(line) do
        {current_filesystem, maybe_update_pwd(line, current_pwd)}
      else
        {maybe_add_element(line, current_pwd, current_filesystem), current_pwd}
      end
    end)
  end

  defp is_command?(line), do: String.starts_with?(line, "$")

  defp maybe_update_pwd("$ ls", pwd), do: pwd

  defp maybe_update_pwd("$ cd ..", pwd), do: remove_one(pwd)

  defp maybe_update_pwd("$ cd /", _pwd), do: "/"

  defp maybe_update_pwd(command, pwd) do
    folder = command |> String.split("$ cd ") |> List.last()
    concat(pwd, folder)
  end

  defp remove_one(file) do
    file |> String.split("/") |> Enum.reverse() |> tl() |> Enum.reverse() |> Enum.join("/")
  end

  defp maybe_add_element(line, pwd, elements) do
    if String.starts_with?(line, "dir") do
      elements
    else
      [size, filename] = String.split(line, " ")
      filepath = concat(pwd, filename)
      [{filepath, String.to_integer(size)} | elements]
    end
  end

  defp concat(left, right) do
    left
    |> Kernel.<>("/")
    |> Kernel.<>(right)
    |> String.replace("//", "/")
  end

  defp find_folders({filesystem, _pwd}) do
    filesystem
    |> Enum.reduce(%{}, fn {file, size}, acc ->
      add_size(acc, file, size)
    end)
    |> Enum.reduce(0, fn {_folder, size}, acc ->
      if size <= 100_000, do: size + acc, else: acc
    end)
  end

  defp find_folder_to_remove({filesystem, _pwd}) do
    aggregated_by_folder =
      filesystem
      |> Enum.reduce(%{}, fn {file, size}, acc ->
        add_size(acc, file, size)
      end)

    space_needed = unused_space_needed(aggregated_by_folder[""])

    with_sizes
    |> Enum.to_list()
    |> Enum.filter(fn {_folder, size} -> size >= space_needed end)
    |> Enum.sort(fn {_folder, size}, {_folder2, size2} -> size <= size2 end)
    |> Enum.take(1)
    |> Enum.at(0)
    |> elem(1)
  end

  defp add_size(filesystem, "", _size), do: filesystem

  defp add_size(filesystem, file, size) do
    base = remove_one(file)
    filesystem = Map.update(filesystem, base, size, fn x -> x + size end)
    add_size(filesystem, base, size)
  end

  defp unused_space_needed(currently_used_space),
    do: 30_000_000 - (70_000_000 - currently_used_space)
end

Solution.part_one() |> IO.inspect()

Solution.part_two() |> IO.inspect()
