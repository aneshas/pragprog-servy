defmodule Servy.PledgeServer do
  @name :pledge_server

  use GenServer

  defmodule State do
    defstruct pledges: [],
              cache_size: 3
  end

  def start_link(initial_state \\ %State{}) do
    IO.puts("Starting the pledge server...")

    GenServer.start_link(__MODULE__, initial_state, name: @name)
  end

  def init(state) do
    state = %{state | pledges: [{"Anes", 100}]}

    {:ok, state}
  end

  def pledge(name, amount) do
    GenServer.call(@name, {:pledge, name, amount})
  end

  def recent_pledges() do
    GenServer.call(@name, :recent_pledges)
  end

  def total() do
    GenServer.call(@name, :total)
  end

  def reset() do
    GenServer.cast(@name, :reset)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  def handle_call({:pledge, name, amount}, _from, state) do
    new_state = %{
      state
      | pledges: [{name, amount} | state.pledges] |> Enum.take(state.cache_size)
    }

    {:reply, new_state, new_state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:total, _from, state) do
    {:reply, Enum.reduce(state.pledges, 0, fn {_, amount}, acc -> acc + amount end), state}
  end

  def handle_cast(:reset, _state) do
    {:noreply, []}
  end

  def handle_cast({:set_cache_size, size}, state) do
    {:noreply, %{state | cache_size: size}}
  end

  def handle_info(msg, state) do
    IO.puts("Unknown message #{inspect(msg)}")
    {:noreply, state}
  end
end
