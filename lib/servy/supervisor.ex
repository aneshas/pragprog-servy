defmodule Servy.Supervisor do
  use Supervisor

  def start_link() do
    IO.puts("Starting the supervisor...")

    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.ServicesSupervisor,
      Servy.KickStarter
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
