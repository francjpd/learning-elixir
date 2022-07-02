defmodule TodoListServer do

  def start(name) do
    spawn(fn ->
      Process.register(self(), name)
      loop(TodoListCrud.new())
    end)
  end

  def add_entry(name, %EntryReload{} = entry) do
    send(name, {:add_entry, self(), entry})
    response = receive do
        {:ok, new_entry} -> new_entry
      after 2000 -> {:error, :timeout}
    end
    response
  end

  def entries(name, date) do
    send(name, {:entries, self(),  date})
    receive do
      {:response, entries} -> entries
    after 2000 -> {:error, :timeout}
    end
  end

  def update_entry(name, entry_id, updater_fun ) do
    send(name, {:update, entry_id, updater_fun})
  end

  def delete_entry(name, %EntryReload{id: entry_id}) do
    send(name, {:delete, entry_id})
  end

  def delete_entry(name, entry_id) do
    send(name, {:delete, entry_id})
  end

  defp loop(%TodoListCrud{} = todo_list) do
    new_todo_list =
      receive do
        message -> process_message(todo_list, message)
      end

    loop(new_todo_list)
  end


  defp process_message(%TodoListCrud{} = current_todo_list, {:add_entry, caller, entry}) do
      new_todo_list = TodoListCrud.add_entry(current_todo_list, entry)
      send(caller, {:ok, entry})
      new_todo_list
  end

  defp process_message(%TodoListCrud{} = current_todo_list, {:entries, caller, date}) do
    entry = current_todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)

    send(caller, {:response, entry})

    current_todo_list
  end

  defp process_message(%TodoListCrud{} = current_todo_list, {:update, entry_id, updater_fun}) do
    case Map.fetch(current_todo_list.entries, entry_id) do
      {:error} -> current_todo_list

      {:ok, old_entry } ->
        new_entry = %EntryReload{} = updater_fun.(old_entry)
        new_entries = Map.replace(current_todo_list.entries,  entry_id, new_entry)
        %TodoListCrud{current_todo_list | entries: new_entries}
    end
  end

  defp process_message(%TodoListCrud{} = current_todo_list, {:delete, %{id: entry_id}}) do
    TodoListCrud.delete_entry(current_todo_list, entry_id)
  end

  defp process_message(%TodoListCrud{} = current_todo_list, {:delete, entry_id}) do
    TodoListCrud.delete_entry(current_todo_list, entry_id)
  end

end
