defmodule Calculator do
  def sum(a), do: sum(a, 0)
  def sum(a, b), do: a + b
  def times(a, b \\ 1, c \\ 1, d \\ 1), do: a * b * c * d
end
