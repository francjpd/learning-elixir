defmodule TodoListReload do
  defimpl String.Chars, for: TodoListReload do
    def to_string(_) do
      "#TodoListReload"
    end
  end

  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoListReload{},
      &add_entry(&2, &1)
      # this is about the same as
      # fn (%EntryReload{} = entry, %TodoListReload{} = todo_list_crud_acc) ->
      #   &add_entry(todo_list_crud_acc, entry)
      # end
    )
  end

  def add_entry(todo_list, %EntryReload{} = entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries =
      Map.put(
        todo_list.entries,
        todo_list.auto_id,
        entry
      )

    %TodoListReload{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      {:error} ->
        todo_list

      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %EntryReload{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoListReload{todo_list | entries: new_entries}
    end
  end

  def update_entry(todo_list, %EntryReload{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def delete_entry(todo_list, %EntryReload{id: entry_id}) do
    delete_entry(todo_list, entry_id)
  end

  def delete_entry(todo_list, entry_id) do
    %TodoListReload{
      todo_list
      | entries: Map.delete(todo_list.entries, entry_id)
    }
  end
end
