defmodule Maze1 do

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
        maze
        |> Map.put(index, offset + 1)
        |> escape_from(index + offset, steps + 1)
    end
  end
end
