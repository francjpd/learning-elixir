defmodule Main do
  def run() do
    test =
      TodoList.new()
      |> TodoList.add_entry(%Entry{date: ~D[2022-06-24], title: "Dentist"})
      |> TodoList.add_entry(%Entry{date: ~D[2022-06-24], title: "Dentist"})
      |> TodoList.add_entry(%Entry{date: ~D[2022-06-24], title: "Dentist"})
      |> TodoList.remove_entry(%Entry{date: ~D[2022-06-24], title: "Dentist"})

    {:ok, test}
  end
end

Main.run()
