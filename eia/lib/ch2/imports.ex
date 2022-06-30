defmodule MyModule do
  import IO
  alias Ch2Geometry.Rectangle

  def my_function do
    puts("Calling an imported function")
  end

  def print_area do
    puts(Rectangle.area(2, 3))
  end
end
