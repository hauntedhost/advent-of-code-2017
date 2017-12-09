defmodule Maze2 do

  def escape_from(maze) when is_list(maze) do
    maze
    |> Enum.with_index
    |> Enum.into(%{}, fn({n, i}) -> {i, n} end)
    |> escape_from(0, 0)
  end

  def escape_from(maze, index, steps) do
    case Map.get(maze, index) do
      nil ->
        steps
      offset ->
        change = case offset do
          n when n >= 3 -> -1
          _             -> 1
        end
        maze
        |> Map.put(index, offset + change)
        |> escape_from(index + offset, steps + 1)
    end
  end
end
