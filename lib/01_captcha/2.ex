defmodule Captcha2 do
  # https://adventofcode.com/2017/day/1

  def solve(num) when is_number(num) do
    num
    |> Integer.digits
    |> solve
  end

  def solve(nums) when is_list(nums) and rem(length(nums), 2) == 0 do
    nums
    |> Enum.reduce(%{
      len: 0,
      nums: [],
      nums_map: %{},
      step: nil,
      sum: 0,
    }, fn(num, result) -> %{result |
        len: result.len + 1,
        nums: [{num, result.len} | result.nums],
        nums_map: Map.put(result.nums_map, result.len, num),
        step: div(result.len + 1, 2),
      }
    end)
    |> Map.update(:nums, nil, fn(nums) -> Enum.reverse(nums) end)
    |> solve
  end

  def solve(%{nums: [], sum: sum}), do: sum

  def solve(%{
    len: len,
    nums: [{num, index} | nums],
    nums_map: nums_map,
    step: step,
    sum: sum,
  }) do
    pos = rem(index + step, len)
    sum = case {num, Map.get(nums_map, pos)} do
      {n, n} -> sum + num
      _      -> sum
    end
    solve(%{
      len: len,
      nums: nums,
      nums_map: nums_map,
      step: step,
      sum: sum,
    })
  end
end
