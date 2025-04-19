defmodule GenericServer do
  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])

    Process.register(pid, name)

    pid
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} ->
        {:response, response, new_state} = callback_module.handle_call(message, state)

        send(sender, {:response, response})

        listen_loop(new_state, callback_module)

      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)

        listen_loop(new_state, callback_module)

      unknown ->
        IO.puts("Unknown message: #{inspect(unknown)}")
        listen_loop(state, callback_module)
    end
  end
end

defmodule Servy.PledgeServer do
  @name :pledge_server

  def start(initial_state \\ []) do
    GenericServer.start(__MODULE__, initial_state, @name)
  end

  def pledge(name, amount) do
    GenericServer.call(@name, {:pledge, name, amount})
  end

  def recent_pledges() do
    GenericServer.call(@name, :recent_pledges)
  end

  def total() do
    GenericServer.call(@name, :total)
  end

  def reset() do
    GenericServer.cast(@name, :reset)
  end

  def handle_call({:pledge, name, amount}, state) do
    new_state = [{name, amount} | state] |> Enum.take(3)

    {:response, new_state, new_state}
  end

  def handle_call(:recent_pledges, state) do
    {:response, state, state}
  end

  def handle_call(:total, state) do
    {:response, Enum.reduce(state, 0, fn {_, amount}, acc -> acc + amount end), state}
  end

  def handle_cast(:reset, _state) do
    []
  end
end
