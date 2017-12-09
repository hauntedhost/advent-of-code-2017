defmodule Passphrase1Test do
  use ExUnit.Case, async: true

  test "phrases.txt returns 383" do
    phrases =
      [File.cwd!, "files", "phrases.txt"]
      |> Path.join
      |> File.read!
      |> String.split("\n", trim: true)

    results = Passphrase1.check(phrases)

    assert Enum.count(results, &(&1 == :ok)) == 383
  end
end
