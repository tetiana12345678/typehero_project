defmodule Typehero.CoreSupervisor do
  def start_link do
    IO.puts "started CoreSupervisor"
    import Supervisor.Spec, warn: false
    children = [
      worker(Typehero.Core, [], [restart: :transient])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
