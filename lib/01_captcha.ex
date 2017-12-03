defmodule Captcha do
  # https://adventofcode.com/2017/day/1

  def solve(number) when is_number(number) do
    [n | _] = ns = Integer.digits(number)
    solve(ns ++ [n], 0)
  end

  defp solve([], sum) do
    sum
  end

  defp solve([n, n | ns], sum) do
    solve([n | ns], sum + n)
  end

  defp solve([_n | ns], sum) do
    solve(ns, sum)
  end
end
