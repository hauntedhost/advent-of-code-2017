defmodule Checksum do
  # https://adventofcode.com/2017/day/2

  def solve(sheet) when is_list(sheet) do
    solve(sheet, 0)
  end

  def solve([], checksum), do: checksum

  def solve([row | rows], checksum) when is_list(row) do
    {min, max} = Enum.min_max(row)
    solve(rows, checksum + (max - min))
  end

  def solve([row | rows], checksum) when is_number(row) do
    solve([Integer.digits(row) | rows], checksum)
  end
end
