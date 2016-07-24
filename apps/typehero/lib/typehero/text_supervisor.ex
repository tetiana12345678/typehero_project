defmodule Typehero.TextSupervisor do
  def start_link do
    import Supervisor.Spec, warn: false
    children = [
      worker(Typehero.Text, [], [restart: :transient])
    ]
    opts = [strategy: :simple_one_for_one, max_restart: 0, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  def start_game do
    Supervisor.start_child(__MODULE__)
  end
end
