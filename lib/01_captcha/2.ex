defmodule Captcha2 do
  # https://adventofcode.com/2017/day/1

  def solve(num) when is_number(num) do
    num
    |> Integer.digits
    |> solve
  end

  def solve(nums) when is_list(nums) and rem(length(nums), 2) == 0 do
    nums = Enum.with_index(nums)
    nums_map = Enum.into(nums, %{}, fn({num, index}) ->
      {index, num}
    end)
    len = length(nums)
    solve(nums, 0, %{
      nums_map: nums_map,
      len: len,
      step: div(len, 2),
    })
  end

  def solve([], sum, _cache), do: sum

  def solve([{num, index} | nums], sum, %{
    nums_map: nums_map,
    len: len,
    step: step,
  }) do
    pos = rem(index + step, len)
    sum = case {num, Map.get(nums_map, pos)} do
      {n, n} -> sum + num
      _      -> sum
    end
    solve(nums, sum, %{
      nums: nums,
      nums_map: nums_map,
      len: len,
      step: step,
    })
  end
end
