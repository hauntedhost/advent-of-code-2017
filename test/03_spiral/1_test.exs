defmodule Spiral1Test do
  use ExUnit.Case, async: true

  test "generate 50 returns expected coordinates" do
    assert %{
      1 => {0, 0},
      2 => {1, 0},
      3 => {1, -1},
      4 => {0, -1},
      10 => {2, 1},
      50 => {4, 3},
    } = Spiral1.generate(50)
  end
end
