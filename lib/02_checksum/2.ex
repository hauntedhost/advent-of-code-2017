defmodule Checksum2 do
  # https://adventofcode.com/2017/day/2

  def solve(sheet) when is_list(sheet) do
    solve(sheet, 0)
  end

  def solve(sheet) when is_binary(sheet) do
    sheet
    |> String.split("\n", trim: true)
    |> solve(0)
  end

  def solve([], checksum), do: checksum

  def solve([row | rows], checksum) when is_list(row) do
    nums = Enum.with_index(row)
    for {a, ai} <- nums, {b, bi} <- nums, ai != bi, rem(a, b) == 0 do
      div(a, b)
    end
    |> case do
      [n | _] -> solve(rows, checksum + n)
      _       -> solve(rows, checksum)
    end
  end

  def solve([row | rows], checksum) when is_number(row) do
    solve([Integer.digits(row) | rows], checksum)
  end

  def solve([row | rows], checksum) when is_binary(row) do
    solve([
      row
      |> String.split
      |> Enum.map(&String.to_integer/1) | rows
    ], checksum)
  end
end
