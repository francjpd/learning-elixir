defmodule TestNum do
  def test(x) when is_number(x) and x < 0 do
    :negative
  end

  def test(0), do: :zero

  def test(x) when is_number(x) and x > 0 do
    :positive
  end
end

_test_num = fn
  x when is_number(x) and x > 0 ->
    :negative

  0 ->
    :zero

  x when is_number(x) and x < 0 ->
    :positive
end
