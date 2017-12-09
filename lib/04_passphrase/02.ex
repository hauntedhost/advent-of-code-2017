defmodule Passphrase2 do

  def check(phrase) when is_binary(phrase) do
    phrase
    |> String.split
    |> Enum.reduce_while(%{}, fn(word, words) ->
      case Map.get(words, word) do
        nil ->
          words =
            word
            |> permutations
            |> Enum.into(%{}, fn(w) -> {w, true} end)
            |> Map.merge(words)
          {:cont, words}
        true ->
          {:halt, :error}
      end
    end)
    |> case do
      :error -> :error
      _      -> :ok
    end
  end

  def check(phrases) when is_list(phrases) do
    Enum.map(phrases, &check/1)
  end

  defp permutations(word) when is_binary(word) do
    word
    |> String.split("", trim: true)
    |> permutations
    |> Enum.map(&Enum.join/1)
  end

  defp permutations([]), do: [[]]
  defp permutations(list) when is_list(list) do
    for head <- list, tail <- permutations(list -- [head]), do: [head | tail]
  end
end
