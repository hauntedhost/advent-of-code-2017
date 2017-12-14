defmodule Memory2Test do
  use ExUnit.Case, async: true

  test "repair [0 2 7 0] returns 4" do
    assert Memory2.repair([0, 2, 7, 0]) == 4
  end

  test "repair memory.txt returns 1695" do
    banks =
      [File.cwd!, "files", "memory.txt"]
      |> Path.join
      |> File.read!
      |> String.split
      |> Enum.map(&String.to_integer/1)

    assert Memory2.repair(banks) ==  1695
  end
end
