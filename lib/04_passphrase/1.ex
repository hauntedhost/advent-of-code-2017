defmodule Passphrase1 do

  def check(phrase) when is_binary(phrase) do
    phrase
    |> String.split
    |> Enum.reduce_while(%{}, fn(word, words) ->
      case Map.get(words, word) do
        nil  -> {:cont, Map.put(words, word, true)}
        true -> {:halt, :error}
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
end
