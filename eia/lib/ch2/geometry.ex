defmodule Geometry do
  defmodule Rectangle do
    def area(b, a) do
      b * a
    end
  end

  defmodule Triangle do
    def area(b, a), do: a * b / 2
  end

  defmodule Square do
    def area(a), do: Rectangle.area(a, a)
  end
end
