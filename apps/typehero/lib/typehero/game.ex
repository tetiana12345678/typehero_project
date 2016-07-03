defmodule Typehero.Game do

  def start_link do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(Typehero.TextSupervisor, []),
      worker(Typehero.GameServer, [])
    ]
    opts = [strategy: :rest_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
