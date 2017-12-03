defmodule Captcha2 do
  # https://adventofcode.com/2017/day/1

  def solve(num) when is_number(num) do
    num
    |> Integer.digits
    |> solve
  end

  def solve(nums) when is_list(nums) and rem(length(nums), 2) == 0 do
    len = length(nums)
    step = div(len, 2)
    nums
    |> Enum.with_index
    |> Enum.reduce(0, fn({n, i}, sum) ->
      pos = rem(i + step, len)
      case {n, Enum.at(nums, pos)} do
        {n, n} -> sum + n
        _      -> sum
      end
    end)
  end
end
