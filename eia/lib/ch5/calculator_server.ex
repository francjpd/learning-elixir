defmodule CalculatorDatabase do
  def start() do
    spawn(fn -> loop(0) end)
  end

  defp loop(current_value) do
    new_value = receive do
      message -> process_message(current_value, message)
    end
    loop(new_value)
  end


  def div(server_pid, value), do: send(server_pid, {:div, value})
  def mul(server_pid, value), do: send(server_pid, {:mul, value})
  def sub(server_pid, value), do: send(server_pid, {:sub, value})
  def sum(server_pid, value), do: send(server_pid, {:sum, value})

  def value(server_pid) do
    send(server_pid, {:value, self()})
    receive do
    {:response, value} -> value
    after 2000 -> {:error, :timeout}
    end
  end

  defp process_message(current_value, {:value, caller}) do
    send(caller, {:response, current_value})
    current_value
  end

  defp process_message(current_value, {:div, value}), do: current_value / value
  defp process_message(current_value, {:mul, value}), do: current_value * value
  defp process_message(current_value, {:sub, value}), do: current_value - value
  defp process_message(current_value, {:sum, value}), do: current_value + value

  defp process_message(current_value, invalid_request) do
    IO.puts("invalid request #{inspect invalid_request}")
      current_value
  end
end
