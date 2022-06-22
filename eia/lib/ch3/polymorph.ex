defmodule Poly do
  def double(x) when is_number(x) do
    x*x
  end
  def double(x) when is_binary(x), do: x <> x
end
