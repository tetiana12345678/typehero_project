defmodule Typehero.TextSupervisor do
  def start_link do
    IO.puts "started TextSupervisor"
    import Supervisor.Spec, warn: false
    children = [
      worker(Typehero.Text, [], [restart: :transient])
    ]
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
