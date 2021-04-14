defmodule KVStore do
  def start do
    Task.start(fn -> loop(%{}) end)
  end

  def get(pid, key, caller) do
    send(pid, {:get, key, caller})
    :ok
  end

  # TODO - Add possibility to add multiple keys at once with keyword list

  def put(pid, key, val) do
    send(pid, {:put, key, val})
    :ok
  end

  def loop(%{} = store) do
    receive do
      {:put, key, value} ->
        store = Map.put(store, key, value)
        loop(store)

      {:get, key, caller} ->
        val = Map.get(store, key)
        send(caller, val)
        loop(store)
    end
  end
end
