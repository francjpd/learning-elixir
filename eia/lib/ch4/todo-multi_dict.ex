defmodule MultiDict do
  def new(), do: %{}

  def add(dict, key, value) do
    Map.update(dict, key, [value], &[value | &1])
  end

  def remove(dict, key, value) do
    dict
    |> Map.get_and_update(
      key,
      fn list_value -> {key, List.delete(list_value, value)} end
    )
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def get(dict, key) do
    Map.get(dict, key, [])
  end
end
