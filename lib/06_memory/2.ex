defmodule Memory2 do
  # http://adventofcode.com/2017/day/6

  def repair(banks) when is_list(banks) do
    banks_map =
      banks
      |> Enum.with_index
      |> Enum.into(%{}, fn({n, i}) -> {i, n} end)
    repair(%{
      banks: banks_map,
      banks_seen: [],
      banks_seen_count: 0,
      blocks_left: 0,
      cycles: 0,
      index: nil,
      index_max: length(banks) - 1,
    })
  end

  def repair(banks) when is_binary(banks) do
    banks
    |> String.split
    |> repair
  end

  def repair(%{
    banks_seen_count: 2,
    cycles: cycles,
  }) do
    cycles
  end

  def repair(memory = %{
    banks: banks,
    banks_seen: banks_seen,
    banks_seen_count: seen_count,
    blocks_left: 0,
    cycles: cycles,
  }) do
    {seen_count, banks_seen} = if banks in banks_seen do
      {seen_count + 1, [banks]}
    else
      {seen_count, [banks | banks_seen]}
    end

    cycles = case seen_count do
      1 -> cycles + 1
      _ -> cycles
    end

    {index, blocks} = max(banks)
    repair(%{memory |
      banks: %{banks | index => 0},
      banks_seen: banks_seen,
      banks_seen_count: seen_count,
      blocks_left: blocks,
      cycles: cycles,
      index: index + 1,
    })
  end

  def repair(memory = %{
    index: index,
    index_max: index_max,
  }) when index > index_max do
    repair(%{memory | index: 0})
  end

  def repair(memory = %{
    banks: banks,
    index: index,
    blocks_left: blocks_left,
  }) do
    repair(%{memory |
      banks: %{banks | index => banks[index] + 1},
      blocks_left: blocks_left - 1,
      index: index + 1,
    })
  end

  # returns tuple {index, max_num}
  def max(banks) do
    Enum.reduce(banks, fn
      ({i, n}, {_, max_n}) when n > max_n -> {i, n}
      ({i, n}, {j, n}) when i < j         -> {i, n}
      (_, result)                         -> result
    end)
  end
end
