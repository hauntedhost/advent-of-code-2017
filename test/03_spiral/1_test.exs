defmodule Spiral1Test do
  use ExUnit.Case, async: true

  test "steps_from 1 returns 0" do
    assert Spiral1.steps(1) == 0
  end

  test "steps_from 12 returns 3" do
    assert Spiral1.steps(12) == 3
  end

  test "steps_from 23 returns 2" do
    assert Spiral1.steps(23) == 2
  end

  test "steps_from 1024 returns 31" do
    assert Spiral1.steps(1024) == 31
  end

  test "steps_from 361_527 returns 326" do
    assert Spiral1.steps(361_527) == 326
  end

  test "generate 2 returns expected coordinates" do
    assert %{
      1 => {0, 0},
      2 => {1, 0},
    } = Spiral1.generate(2)
  end

  test "generate 50 returns expected coordinates" do
    assert %{
      49 => {3, 3},
      50 => {4, 3},
    } = Spiral1.generate(50)
  end
end
