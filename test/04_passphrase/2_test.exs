defmodule Passphrase2Test do
  use ExUnit.Case, async: true

  @tag :skip
  test "phrases.txt returns 265" do
    phrases =
      [File.cwd!, "files", "phrases.txt"]
      |> Path.join
      |> File.read!
      |> String.split("\n", trim: true)

    results = Passphrase2.check(phrases)

    assert Enum.count(results, &(&1 == :ok)) == 265
  end
end
