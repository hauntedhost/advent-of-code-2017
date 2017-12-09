defmodule Maze1Test do
  use ExUnit.Case, async: true

  test "escape_from [0 3 0 1 -3] returns 5" do
    assert Maze1.escape_from([0, 3, 0, 1, -3]) == 5
  end

  test "escape from maze.txt returns 318883" do
    maze =
      [File.cwd!, "files", "maze.txt"]
      |> Path.join
      |> File.read!
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    assert Maze1.escape_from(maze) == 318883
  end
end
