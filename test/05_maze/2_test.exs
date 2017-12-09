defmodule Maze2Test do
  use ExUnit.Case, async: true

  test "escape_from [0 3 0 1 -3] returns 10" do
    assert Maze2.escape_from([0, 3, 0, 1, -3]) == 10
  end

  @tag :skip
  test "escape from maze.txt returns 23948711" do
    maze =
      [File.cwd!, "files", "maze.txt"]
      |> Path.join
      |> File.read!
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    assert Maze2.escape_from(maze) == 23948711
  end
end
